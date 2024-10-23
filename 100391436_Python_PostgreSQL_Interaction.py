'''
Before you can run this code, please do the following:
    Fill up the information in line 23 below "connStr = "host='cmpstudb-01.cmp.uea.ac.uk' dbname= '' user='' password = " + pw"
    using the Russell Smith's provided credentials', add your password in the pw.txt file.

    Get connected to VPN (https://my.uea.ac.uk/divisions/it-and-computing-services/service-catalogue/network-and-telephony-services/vpn) if you are running this code from an off-campus location.

    Get the server running in https://pgadmin.cmp.uea.ac.uk/ by log into the server.

'''

import psycopg2
import pandas as pd
#from sqlalchemy.engine import URL


def getConn():
    # function to retrieve the password, construct
    # the connection string, make a connection and return it.
    # The pw.txt file will have the password to access the PGAdmin given to you by Russell Smith
    pwFile = open("pw.txt", "r")
    pw = pwFile.read();
    pwFile.close()
    # Fill up the following information from the Russell Smith's email.
    connStr = "host='cmpstudb-01.cmp.uea.ac.uk' \
               dbname= 'txn22ydu' user='txn22ydu' password = " + pw
    # connStr=("dbname='studentdb' user='dbuser' password= 'dbPassword' " )
    conn = psycopg2.connect(connStr)
    return conn


def clearOutput():
    with open("output.txt", "w") as clearfile:
        clearfile.write('')


def writeOutput(output):
    with open("output.txt", "a") as myfile:
        myfile.write(output)


try:
    conn = None
    conn = getConn()
    # All the sql statement once run will be autocommited
    conn.autocommit = True
    cur = conn.cursor()
    f = open("input.txt", "r")
    clearOutput()
    for x in f:
        print(x)
        if (x[0] == 'A'):
            raw = x.split("#", 1)
            raw[1] = raw[1].strip()
            data = raw[1].split("#")
            # Statement to insert data into the student table
            try:
                cur.execute("SET SEARCH_PATH TO amazonia, public;");
                sql = "INSERT INTO book(bno, title, author, category, price) values ({},'{}','{}','{}',{})".format(
                    data[0], data[1], data[2], data[3], data[4]);
                writeOutput("TASK " + x[0] + "\n")
                cur.execute(sql)
                writeOutput(cur.statusmessage + "\n")
            except Exception as e:
                writeOutput(str(e) + "\n")
            try:
                cur.execute("SET SEARCH_PATH TO amazonia, public;");
                sql = "SELECT * FROM book"
                cur.execute(sql)
                writeOutput(cur.statusmessage + "\n")
                table_df = pd.read_sql_query(sql, conn)
                # Converting dataframe to string so that it can be written to text file.
                table_str = table_df.to_string()
                writeOutput(table_str + "\n")
            except Exception as e:
                print(e)
        if (x[0] == 'B'):
            raw = x.split("#", 1)
            raw[1] = raw[1].strip()
            data = raw[1].split("#")
            # Statement to insert data into the student table
            try:
                cur.execute("SET SEARCH_PATH TO amazonia, public;");
                sql = "DELETE FROM book WHERE bno = {};".format(data[0]);
                writeOutput("TASK " + x[0] + "\n")
                cur.execute(sql)
                writeOutput(cur.statusmessage + "\n")
            except Exception as e:
                writeOutput(str(e) + "\n")

            try:
                cur.execute("SET SEARCH_PATH TO amazonia, public;");
                sql = "SELECT * FROM book"
                # Sending the query and connection object to read_sql_query method of pandas pd. It reurns table as dataframe.
                cur.execute(sql)
                writeOutput(cur.statusmessage + "\n")
                table_df = pd.read_sql_query(sql, conn)
                # Converting dataframe to string so that it can be written to text file.
                table_str = table_df.to_string()
                writeOutput(table_str + "\n")
            except Exception as e:
                print(e)
        if (x[0] == 'C'):
            raw = x.split("#", 1)
            raw[1] = raw[1].strip()
            data = raw[1].split("#")
            # Statement to insert data into the student table
            try:
                cur.execute("SET SEARCH_PATH TO amazonia, public;");
                sql = "INSERT INTO customer(cno, name, address) values ({},'{}','{}')".format(data[0], data[1],
                                                                                              data[2]);
                writeOutput("TASK " + x[0] + "\n")
                cur.execute(sql)
                writeOutput(cur.statusmessage + "\n")
            except Exception as e:
                writeOutput(str(e) + "\n")
            try:
                cur.execute("SET SEARCH_PATH TO amazonia, public;");
                sql = "SELECT * FROM customer"
                # Sending the query and connection object to read_sql_query method of pandas pd. It reurns table as dataframe.
                cur.execute(sql)
                writeOutput(cur.statusmessage + "\n")
                table_df = pd.read_sql_query(sql, conn)
                # Converting dataframe to string so that it can be written to text file.
                table_str = table_df.to_string()
                writeOutput(table_str + "\n")
            except Exception as e:
                print(e)

        if (x[0] == 'D'):
            raw = x.split("#", 1)
            raw[1] = raw[1].strip()
            data = raw[1].split("#")
            # Statement to insert data into the student table
            try:
                cur.execute("SET SEARCH_PATH TO amazonia, public;");
                sql = "DELETE FROM customer WHERE cno = {};".format(data[0]);
                writeOutput("TASK " + x[0] + "\n")
                cur.execute(sql)
                writeOutput(cur.statusmessage + "\n")
            except Exception as e:
                writeOutput(str(e) + "\n")
            try:
                cur.execute("SET SEARCH_PATH TO amazonia, public;");
                sql = "SELECT * FROM customer"
                # Sending the query and connection object to read_sql_query method of pandas pd. It reurns table as dataframe.
                cur.execute(sql)
                writeOutput(cur.statusmessage + "\n")
                table_df = pd.read_sql_query(sql, conn)
                # Converting dataframe to string so that it can be written to text file.
                table_str = table_df.to_string()
                writeOutput(table_str + "\n")
            except Exception as e:
                print(e)
        if (x[0] == 'E'):
            raw = x.split("#", 1)
            raw[1] = raw[1].strip()
            data = raw[1].split("#")
            # Statement to insert data into the student table
            try:
                cur.execute("SET SEARCH_PATH TO amazonia, public;");
                sql = "call place_order({},{},{})".format(data[0], data[1], data[2]);
                writeOutput("TASK " + x[0] + "\n")
                cur.execute(sql)
                writeOutput(cur.statusmessage + "\n")
            except Exception as e:
                writeOutput(str(e) + "\n")

            try:
                cur.execute("SET SEARCH_PATH TO amazonia, public;");
                sql = "SELECT * FROM customer"
                # Sending the query and connection object to read_sql_query method of pandas pd. It reurns table as dataframe.
                cur.execute(sql)
                writeOutput(cur.statusmessage + "\n")
                table_df = pd.read_sql_query(sql, conn)
                # Converting dataframe to string so that it can be written to text file.
                table_str = table_df.to_string()
                writeOutput(table_str + "\n")
            except Exception as e:
                print(e)
            try:
                cur.execute("SET SEARCH_PATH TO amazonia, public;");
                sql = "SELECT * FROM book"
                # Sending the query and connection object to read_sql_query method of pandas pd. It reurns table as dataframe.
                cur.execute(sql)
                writeOutput(cur.statusmessage + "\n")
                table_df = pd.read_sql_query(sql, conn)
                # Converting dataframe to string so that it can be written to text file.
                table_str = table_df.to_string()
                writeOutput(table_str + "\n")
            except Exception as e:
                print(e)
            try:
                cur.execute("SET SEARCH_PATH TO amazonia, public;");
                sql = "SELECT * FROM bookOrder"
                # Sending the query and connection object to read_sql_query method of pandas pd. It reurns table as dataframe.
                cur.execute(sql)
                writeOutput(cur.statusmessage + "\n")
                table_df = pd.read_sql_query(sql, conn)
                # Converting dataframe to string so that it can be written to text file.
                table_str = table_df.to_string()
                writeOutput(table_str + "\n")
            except Exception as e:
                print(e)
        if (x[0] == 'F'):
            raw = x.split("#", 1)
            raw[1] = raw[1].strip()
            data = raw[1].split("#")
            # Statement to insert data into the student table
            try:
                cur.execute("SET SEARCH_PATH TO amazonia, public;");
                sql = "call transfer_amt({},{})".format(data[0], data[1]);
                writeOutput("TASK " + x[0] + "\n")
                cur.execute(sql)
                writeOutput(cur.statusmessage + "\n")
            except Exception as e:
                writeOutput(str(e) + "\n")
            try:
                cur.execute("SET SEARCH_PATH TO amazonia, public;");
                sql = "SELECT * FROM record WHERE pay_cno = {};".format(data[0]);
                # Sending the query and connection object to read_sql_query method of pandas pd. It reurns table as dataframe.
                cur.execute(sql)
                writeOutput(cur.statusmessage + "\n")
                table_df = pd.read_sql_query(sql, conn)
                # Converting dataframe to string so that it can be written to text file.
                table_str = table_df.to_string()
                writeOutput(table_str + "\n")
            except Exception as e:
                print(e)

        if (x[0] == 'G'):
            raw = x.split("#", 1)
            raw[1] = raw[1].strip()
            data = raw[1].split("#")
            # Statement to insert data into the student table
            try:
                cur.execute("SET SEARCH_PATH TO amazonia, public;");
                sql = "SELECT * FROM title_check where title like '%{}%';".format(data[0])
                writeOutput("TASK " + x[0] + "\n")
                # Sending the query and connection object to read_sql_query method of pandas pd. It reurns table as dataframe.
                cur.execute(sql)
                writeOutput(cur.statusmessage + "\n")
                table_df = pd.read_sql_query(sql, conn)
                # Converting dataframe to string so that it can be written to text file.
                table_str = table_df.to_string()
                writeOutput(table_str + "\n")
            except Exception as e:
                print(e)
        if (x[0] == 'H'):
            raw = x.split("#", 1)
            raw[1] = raw[1].strip()
            data = raw[1].split("#")
            # Statement to insert data into the student table
            try:
                cur.execute("SET SEARCH_PATH TO amazonia, public;");
                sql = "SELECT * FROM cust_book where name = (select name from customer where cno = {});".format(
                    data[0])
                writeOutput("TASK " + x[0] + "\n")
                # Sending the query and connection object to read_sql_query method of pandas pd. It reurns table as dataframe.
                cur.execute(sql)
                writeOutput(cur.statusmessage + "\n")
                table_df = pd.read_sql_query(sql, conn)
                # Converting dataframe to string so that it can be written to text file.
                table_str = table_df.to_string()
                writeOutput(table_str + "\n")
            except Exception as e:
                print(e)
        if (x[0] == 'I'):
            # raw = x.split("#", 1)
            # raw[1] = raw[1].strip()
            # data = raw[1].split("#")
            # Statement to insert data into the student table
            try:
                cur.execute("SET SEARCH_PATH TO amazonia, public;");
                sql = "SELECT * FROM book_report";
                writeOutput("TASK " + x[0] + "\n")
                # Sending the query and connection object to read_sql_query method of pandas pd. It reurns table as dataframe.
                cur.execute(sql)
                writeOutput(cur.statusmessage + "\n")
                table_df = pd.read_sql_query(sql, conn)
                # Converting dataframe to string so that it can be written to text file.
                table_str = table_df.to_string()
                writeOutput(table_str + "\n")
            except Exception as e:
                print(e)
        if (x[0] == 'J'):
            #  raw = x.split("#", 1)
            # raw[1] = raw[1].strip()
            # data = raw[1].split("#")
            # Statement to insert data into the student table
            try:
                cur.execute("SET SEARCH_PATH TO amazonia, public;");
                sql = "select * from customer_report";
                writeOutput("TASK " + x[0] + "\n")
                # Sending the query and connection object to read_sql_query method of pandas pd. It reurns table as dataframe.
                cur.execute(sql)
                writeOutput(cur.statusmessage + "\n")
                table_df = pd.read_sql_query(sql, conn)
                # Converting dataframe to string so that it can be written to text file.
                table_str = table_df.to_string()
                writeOutput(table_str + "\n")
            except Exception as e:
                print(e)
        elif (x[0] == 'X'):
            print("Exit {}".format(x[0]))
            writeOutput("\n\nExit program!")
except Exception as e:
    print(e)
