#include <cstdio>
#include <cstdlib>
#include <ctime>

bool leap(int year) {
    return (year % 400 == 0 || (year % 100 != 0 && year % 4 == 0));
}

int main() {
    freopen("table.sql", "w", stdout);
    int a_id, t_id = 1;
    printf("DROP TABLE IF EXISTS TRANSACTIONS;\n");
    printf("DROP TABLE IF EXISTS ACCOUNT;\n");
    printf("CREATE TABLE ACCOUNT (\n\tA_ID INT PRIMARY KEY\n);\n");
    printf("\n");
    printf("CREATE TABLE TRANSACTIONS (\n\tT_ID INT PRIMARY KEY,\n\tDTM DATETIME,\n\tA_ID INT,\n\tAMOUNT DECIMAL(10,2),\n\tTYPE CHAR(1),\n\tFOREIGN KEY (A_ID) REFERENCES ACCOUNT(A_ID)\n);\n");
    printf("\n\n");
    srand(time(NULL));
    int no_of_accounts = 100 + rand() % 200;
    for (int i = 0; i < no_of_accounts; i++) {
        printf("INSERT INTO ACCOUNT VALUES(%d);\n", i + 1);
    }
    printf("\n");
    for (int i = 0; i < no_of_accounts; i++) {
        int times = rand() % 10 + 1;
        for (int k = 0; k < times; k++) {
            int amount = 100000 + rand() % 900000;
            int year = rand() % 17 + 2000;
            int month = rand() % 12 + 1;
            int day = rand() % 28 + 1;
            if (rand() % 2 && leap(year)) day++;
            int hour = rand() % 24, minute = rand() % 60, second = rand() % 60;
            int type = rand() % 2;
            printf(
                "INSERT INTO TRANSACTIONS VALUES(%d, '%d-%02d-%02d %02d:%02d:%02d', %d, %d.%02d, '%c');\n",
                t_id++, year, month, day, hour, minute, second, i + 1, amount / 100, amount % 100, type ? '0' : '1');
        }
    }
    printf("COMMIT;\n");
    return 0;
}
