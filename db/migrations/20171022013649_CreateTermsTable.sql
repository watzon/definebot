-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE IF NOT EXISTS terms(
    id              INT PRIMARY KEY     NOT NULL,
    word            VARCHAR             NOT NULL,
    definition      TEXT                NOT NULL,
    link            VARCHAR
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE terms;