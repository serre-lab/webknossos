update webknossos.tasktypes
set settings_allowedmagnifications = '{"min":1,"max":1,"shouldRestrict":true}'
where (tracingtype = 'volume' or tracingtype = 'hybrid')
and (settings_allowedmagnifications is null or settings_allowedmagnifications::json->>'shouldRestrict'='false');
