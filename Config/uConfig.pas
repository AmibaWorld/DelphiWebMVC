unit uConfig;

interface

uses
  DBMySql, DBSQLite, DBMSSQL, DBMSSQL12, DBOracle;

type
  TDB = TDBSQLite;                // TDBMySql,TDBSQLite,TDBMSSQL,TDBMSSQL12(2012�汾����),TDBOracle

const
  db_type = 'SQLite';             // MYSQL,SQLite,MSSQL,ORACLE
  __APP__='';            // Ӧ������ ,�ɵ�������Ŀ¼ʹ��
  template = 'view';              // ģ���Ŀ¼
  template_type = '.html';        // ģ���ļ�����
  session_start = true;           // ����session
  session_timer = 0;              // session����ʱ�����  0 ������
  config = 'resources\config.json';         // �����ļ���ַ
  mime = 'resources\mime.json';             // mime�����ļ���ַ
  open_log = true;                // ������־;open_debug=true��������־����UI��ʾ
  open_cache = true;              // ��������ģʽopen_debug=falseʱ��Ч
  open_interceptor = false;        // ����������
  default_charset = 'utf-8';      // �ַ���
  password_key = '';              // �����ļ���Կ����,Ϊ��ʱ��������Կ,��ϼ��ܹ���ʹ��.
  auto_free_memory = false;          //�Զ��ͷ��ڴ�
  auto_free_memory_timer = 10;      //Ĭ��10�����ͷ��ڴ�
  open_debug = false;              // ������ģʽ���湦�ܽ���ʧЧ,����ǰ���������������

implementation

end.

