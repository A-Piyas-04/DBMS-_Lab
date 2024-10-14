-- Given
drop table depositor;
drop table borrower;
drop table account;
drop table loan;
drop table customer;
drop table branch;

create table branch
   (branch_name 	varchar(15)	not null,
    branch_city 	varchar(15)	not null,
    assets 		number		not null,
    primary key(branch_name));
    
create table customer
   (customer_name 	varchar(15)	not null,
    customer_street 	varchar(12)	not null,
    customer_city 	varchar(15)	not null,
    primary key(customer_name));

create table account
   (account_number 	varchar(15)	not null,
    branch_name		varchar(15)	not null,
    balance 		number		not null,
    primary key(account_number),
    foreign key(branch_name) references branch(branch_name));


create table loan
   (loan_number 	varchar(15)	not null,
    branch_name		varchar(15)	not null,
    amount 		number		not null,
    primary key(loan_number),
    foreign key(branch_name) references branch(branch_name));

create table depositor
   (customer_name 	varchar(15)	not null,
    account_number 	varchar(15)	not null,
    primary key(customer_name, account_number),
    foreign key(account_number) references account(account_number),
    foreign key(customer_name) references customer(customer_name));

create table borrower
   (customer_name 	varchar(15)	not null,
    loan_number 	varchar(15)	not null,
    primary key(customer_name, loan_number),
    foreign key(customer_name) references customer(customer_name),
    foreign key(loan_number) references loan(loan_number));

-- populate relations 

insert into customer	values ('Jones',	'Main',		'Harrison');
insert into customer	values ('Smith',	'Main',		'Rye');
insert into customer	values ('Hayes',	'Main',		'Harrison');
insert into customer	values ('Curry',	'North',	'Rye');
insert into customer	values ('Lindsay',	'Park',		'Pittsfield');
insert into customer	values ('Turner',	'Putnam',	'Stamford');
insert into customer	values ('Williams',	'Nassau',	'Princeton');
insert into customer	values ('Adams',	'Spring',	'Pittsfield');
insert into customer	values ('Johnson',	'Alma',		'Palo Alto');
insert into customer	values ('Glenn',	'Sand Hill',	'Woodside');
insert into customer	values ('Brooks',	'Senator',	'Brooklyn');
insert into customer	values ('Green',	'Walnut',	'Stamford');
insert into customer	values ('Jackson',	'University',	'Salt Lake');
insert into customer	values ('Majeris',	'First',	'Rye');
insert into customer	values ('McBride',	'Safety',	'Rye');

insert into branch	values ('Downtown',	'Brooklyn',	 900000);
insert into branch	values ('Redwood',	'Palo Alto',	2100000);
insert into branch	values ('Perryridge',	'Horseneck',	1700000);
insert into branch	values ('Mianus',	'Horseneck',	 400200);
insert into branch	values ('Round Hill',	'Horseneck',	8000000);
insert into branch	values ('Pownal',	'Bennington',	 400000);
insert into branch	values ('North Town',	'Rye',		3700000);
insert into branch	values ('Brighton',	'Brooklyn',	7000000);
insert into branch	values ('Central',	'Rye',		 400280);

insert into account	values ('A-101',	'Downtown',	500);
insert into account	values ('A-215',	'Mianus',	700);
insert into account	values ('A-102',	'Perryridge',	400);
insert into account	values ('A-305',	'Round Hill',	350);
insert into account	values ('A-201',	'Perryridge',	900);
insert into account	values ('A-222',	'Redwood',	700);
insert into account	values ('A-217',	'Brighton',	750);
insert into account	values ('A-333',	'Central',	850);
insert into account	values ('A-444',	'North Town',	625);

insert into depositor values ('Johnson','A-101');
insert into depositor values ('Smith',	'A-215');
insert into depositor values ('Hayes',	'A-102');
insert into depositor values ('Hayes',	'A-101');
insert into depositor values ('Turner',	'A-305');
insert into depositor values ('Johnson','A-201');
insert into depositor values ('Jones',	'A-217');
insert into depositor values ('Lindsay','A-222');
insert into depositor values ('Majeris','A-333');
insert into depositor values ('Smith',	'A-444');

insert into loan	values ('L-17',		'Downtown',	1000);
insert into loan	values ('L-23',		'Redwood',	2000);
insert into loan	values ('L-15',		'Perryridge',	1500);
insert into loan	values ('L-14',		'Downtown',	1500);
insert into loan	values ('L-93',		'Mianus',	500);
insert into loan	values ('L-11',		'Round Hill',	900);
insert into loan	values ('L-16',		'Perryridge',	1300);
insert into loan	values ('L-20',		'North Town',	7500);
insert into loan	values ('L-21',		'Central',	570);

insert into borrower values ('Jones',	'L-17');
insert into borrower values ('Smith',	'L-23');
insert into borrower values ('Hayes',	'L-15');
insert into borrower values ('Jackson',	'L-14');
insert into borrower values ('Curry',	'L-93');
insert into borrower values ('Smith',	'L-11');
insert into borrower values ('Williams','L-17');
insert into borrower values ('Adams',	'L-16');
insert into borrower values ('McBride',	'L-20');
insert into borrower values ('Smith',	'L-21');

commit;

--  Task

-- 1
SELECT DISTINCT customer.customer_name, customer.customer_city
FROM customer
JOIN borrower ON customer.customer_name = borrower.customer_name
WHERE customer.customer_name NOT IN (SELECT customer_name FROM depositor);

-- 2
-- with set operator:
SELECT customer_name FROM customer
WHERE customer_name IN (SELECT customer_name FROM depositor)
   AND customer_name IN (SELECT customer_name FROM borrower);

-- without set operator:
SELECT DISTINCT customer.customer_name
FROM customer
JOIN borrower ON customer.customer_name = borrower.customer_name
JOIN depositor ON customer.customer_name = depositor.customer_name;

-- 3
-- with set operator:
SELECT * FROM customer
WHERE customer_name IN (SELECT customer_name FROM depositor)
   OR customer_name IN (SELECT customer_name FROM borrower);

-- without set operator:
SELECT DISTINCT customer.*
FROM customer
LEFT JOIN depositor ON customer.customer_name = depositor.customer_name
LEFT JOIN borrower ON customer.customer_name = borrower.customer_name
WHERE depositor.customer_name IS NOT NULL OR borrower.customer_name IS NOT NULL;

-- 4
SELECT SUM(assets) AS total_assets
FROM branch;

-- 5
SELECT branch.branch_city, COUNT(account.account_number) AS total_accounts
FROM branch
JOIN account ON branch.branch_name = account.branch_name
GROUP BY branch.branch_city;

-- 6
SELECT account.branch_name, AVG(account.balance) AS average_balance
FROM account
GROUP BY account.branch_name
ORDER BY average_balance DESC;

-- 7
SELECT branch.branch_name, AVG(loan.amount) AS average_loan
FROM branch
JOIN loan ON branch.branch_name = loan.branch_name
WHERE branch.branch_city NOT LIKE '%Horse%'
GROUP BY branch.branch_name;

-- 8
SELECT depositor.customer_name, account.account_number
FROM account
JOIN depositor ON account.account_number = depositor.account_number
ORDER BY account.balance DESC
LIMIT 1;

-- 9
SELECT DISTINCT customer.*
FROM customer
JOIN depositor ON customer.customer_name = depositor.customer_name
JOIN account ON depositor.account_number = account.account_number
JOIN branch ON account.branch_name = branch.branch_name
WHERE customer.customer_city = branch.branch_city;

-- 10
SELECT branch.branch_city, AVG(loan.amount) AS average_loan_amount
FROM branch
JOIN loan ON branch.branch_name = loan.branch_name
GROUP BY branch.branch_city
HAVING AVG(loan.amount) >= 1500;

-- 11
SELECT branch_name
FROM (
    SELECT branch_name, SUM(balance) AS total_balance
    FROM account
    GROUP BY branch_name
) AS branch_totals
WHERE total_balance > (
    SELECT AVG(total_balance)
    FROM (
        SELECT SUM(balance) AS total_balance
        FROM account
        GROUP BY branch_name
    ) AS total_balances
);

-- 12
SELECT DISTINCT customer.customer_name
FROM customer
JOIN depositor ON customer.customer_name = depositor.customer_name
JOIN borrower ON customer.customer_name = borrower.customer_name
JOIN account ON depositor.account_number = account.account_number
JOIN loan ON borrower.loan_number = loan.loan_number
WHERE account.balance >= loan.amount;

-- 13
SELECT DISTINCT branch.*
FROM branch
WHERE branch.branch_city IN (
    SELECT customer.customer_city
    FROM customer
    LEFT JOIN depositor ON customer.customer_name = depositor.customer_name
    LEFT JOIN borrower ON customer.customer_name = borrower.customer_name
    WHERE depositor.customer_name IS NULL AND borrower.customer_name IS NULL
)
AND EXISTS (
    SELECT 1
    FROM loan
    WHERE loan.branch_name = branch.branch_name
)
AND EXISTS (
    SELECT 1
    FROM account
    WHERE account.branch_name = branch.branch_name
);