USE conky;

DROP TABLE IF EXISTS t_todo;

CREATE TABLE IF NOT EXISTS t_todo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo TEXT CHECK (tipo IN ('note', 'task', 'safe')),
    texto TEXT,
    ok BIT,
    UNIQUE(id)
) ENGINE=InnoDB;

INSERT INTO t_todo (tipo,texto, ok) VALUES
('note', ' ', 0);
