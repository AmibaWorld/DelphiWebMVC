unit uConfig;

interface
uses DBMySql,DBSQLite,DBMSSQL,DBMSSQL12,DBOracle;
type TDB = TDBMySql;         // TDBMySql,TDBSQLite,TDBMSSQL,TDBMSSQL12(2012�汾����),TDBOracle
const
  db_type='MYSQL';           // MYSQL,SQLite,MSSQL,ORACLE
  db_start = true;            // �������ݿ�
  template = 'view';          // ģ���Ŀ¼
  template_type = '.html';    // ģ���ļ�����
  session_start = true;       // ����session
  session_timer = 0;          // session����ʱ�����  0 ������
  config = 'config.ini';      // ���ݿ������ļ���ַ
  open_log=true;              // ����־
  default_charset='utf-8';    // �ַ���

implementation

end.
