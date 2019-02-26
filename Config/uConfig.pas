unit uConfig;

interface

uses
  DBMySql, DBSQLite, DBMSSQL, DBMSSQL12, DBOracle;

type
  TDB = TDBMySql;                          // TDBMySql,TDBSQLite,TDBMSSQL,TDBMSSQL12(2012�汾����),TDBOracle
 // TDB2=TDBMSSQL;

const
  db_type = 'MYSQL';                       // MYSQL,SQLite,MSSQL,ORACLE
 // db_type2 = 'MSSQL';                       // MYSQL,SQLite,MSSQL,ORACLE
  __APP__='Admin';            // Ӧ������ ,�ɵ�������Ŀ¼ʹ��
  template = 'view';                        // ģ���Ŀ¼
  template_type = '.html';                  // ģ���ļ�����
  session_start = true;                     // ����session
  session_timer = 0;                        // session����ʱ�����  0 ������
  config = 'resources/config.json';         // �����ļ���ַ
  mime = 'resources/mime.json';             // mime�����ļ���ַ
  package_config = 'resources/package.json';  // bpl�������ļ�
  bpl_Reload_timer = 5;                       // bpl�����ʱ���� Ĭ��5��
  bpl_unload_timer = 10;                      // bpl��ж��ʱ���� Ĭ��10�룬�����°���ȴ�10��ж�ؾɰ�
  open_package = true;                        // ʹ�� bpl������ģʽ
  open_log = true;                          // ������־;open_debug=true��������־����UI��ʾ
  open_cache = true;                        // ��������ģʽopen_debug=falseʱ��Ч
  open_interceptor = true;                  // ����������
  default_charset = 'utf-8';                // �ַ���
  password_key = '';                        // �����ļ���Կ����,Ϊ��ʱ��������Կ,��ϼ��ܹ���ʹ��.
  auto_free_memory = false;          //�Զ��ͷ��ڴ�
  auto_free_memory_timer = 10;      //Ĭ��10�����ͷ��ڴ�
  open_debug = false;                        // ������ģʽ���湦�ܽ���ʧЧ,����ǰ���������������

implementation

end.

