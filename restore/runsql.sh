#!/bin/bash
PGPASSWORD="postgres" psql -h 127.0.0.1 -p 5432 -U postgres -d webknossos --set ON_ERROR_STOP=on -f $1 
