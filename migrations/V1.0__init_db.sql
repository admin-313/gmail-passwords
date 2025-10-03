-- Custom ENUM types
CREATE TYPE user_role AS ENUM ('user', 'admin');
CREATE TYPE user_status AS ENUM ('active', 'deactivated');
CREATE TYPE email_status AS ENUM ('active', 'deactivated');
CREATE TYPE operation_type AS ENUM ('get', 'add', 'remove', 'deactivate', 'promote');
CREATE TYPE operation_result AS ENUM ('success', 'failed', 'rejected');

-- Users table
CREATE TABLE users (
    slack_id VARCHAR(20) PRIMARY KEY,
    username VARCHAR(64) NOT NULL,
    status user_status NOT NULL DEFAULT 'active',
    role user_role NOT NULL DEFAULT 'user',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Emails table
CREATE TABLE emails (
    email_address VARCHAR(128) PRIMARY KEY,
    password VARCHAR(128) NOT NULL,
    status email_status NOT NULL DEFAULT 'active',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Junction table: users <-> emails
CREATE TABLE users_emails (
    slack_id VARCHAR(20) NOT NULL,
    email_address VARCHAR(128) NOT NULL,
    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    PRIMARY KEY (slack_id, email_address),
    
    CONSTRAINT fk_users_emails_slack_id
        FOREIGN KEY (slack_id) 
        REFERENCES users(slack_id)
        ON DELETE CASCADE,
    
    CONSTRAINT fk_users_emails_email_address
        FOREIGN KEY (email_address) 
        REFERENCES emails(email_address)
        ON DELETE CASCADE
);

-- Audit log table
CREATE TABLE traces (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    slack_id VARCHAR(20) NOT NULL,
    username VARCHAR(64), -- Stored for history
    email_address VARCHAR(128) NOT NULL,
    operation operation_type NOT NULL,
    result operation_result NOT NULL,
    recorded_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    
    CONSTRAINT fk_traces_slack_id
        FOREIGN KEY (slack_id) 
        REFERENCES users(slack_id)
        ON DELETE SET NULL,
    
    CONSTRAINT fk_traces_email_address
        FOREIGN KEY (email_address) 
        REFERENCES emails(email_address)
        ON DELETE SET NULL
);

-- Essential indexes
CREATE INDEX idx_users_emails_email ON users_emails(email_address);
CREATE INDEX idx_traces_slack_id ON traces(slack_id);
CREATE INDEX idx_traces_email ON traces(email_address);
CREATE INDEX idx_traces_recorded_at ON traces(recorded_at DESC);