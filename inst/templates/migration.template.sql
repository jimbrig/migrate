/**

Version : {{version}}
Name    : {{name}}
Date    : {{date}}

**/

-- migrate:up

BEGIN TRANSACTION;

{{sql_up}}

COMMIT;

-- migrate:down

BEGIN TRANSACTION;

{{sql_down}}

COMMIT;


