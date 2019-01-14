unit uConfig;

interface

uses
  DBMySql, DBSQLite, DBMSSQL, DBMSSQL12, DBOracle;

type
  TDB = TDBMySql;                // TDBMySql,TDBSQLite,TDBMSSQL,TDBMSSQL12(2012�汾����),TDBOracle

const
  db_type = 'MYSQL';             // MYSQL,SQLite,MSSQL,ORACLE
  db_start = true;                // �������ݿ�
  template = 'view';              // ģ���Ŀ¼
  template_type = '.html';        // ģ���ļ�����
  session_start = true;           // ����session
  session_timer = 0;              // session����ʱ�����  0 ������
  config = 'config.json';         // �����ļ���ַ
  mime = 'mime.json';             // mime�����ļ���ַ
  package_config='package.json';  // bpl�������ļ�
  open_package=true;              // ʹ�� bpl������ģʽ
  open_log = true;                // ������־;open_debug=true��������־����UI��ʾ
  open_cache = true;              // ��������ģʽopen_debug=falseʱ��Ч
  open_interceptor = true;        // ����������
  default_charset = 'utf-8';      // �ַ���
  password_key = '';              // �����ļ���Կ����,Ϊ��ʱ��������Կ,��ϼ��ܹ���ʹ��.

  open_debug = true;              // ������ģʽ���湦�ܽ���ʧЧ,����ǰ���������������

implementation

end.

