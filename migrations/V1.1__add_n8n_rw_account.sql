CREATE USER n8n_rw WITH ENCRYPTED PASSWORD 'CHANGEME&';
GRANT CONNECT ON DATABASE n8n TO n8n_rw;

-- 3. Grant USAGE on the public schema
GRANT USAGE ON SCHEMA public TO n8n_rw;

-- 4. Grant data manipulation privileges on all existing tables
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO n8n_rw;

-- 5. Grant privileges on all existing sequences (for auto-increment columns)
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO n8n_rw;

-- 6. Set default privileges for future tables (important!)
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO n8n_rw;

-- 7. Set default privileges for future sequences
ALTER DEFAULT PRIVILEGES IN SCHEMA public 
GRANT USAGE, SELECT ON SEQUENCES TO n8n_rw;