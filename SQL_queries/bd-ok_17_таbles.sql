DROP DATABASE IF EXISTS ok;
CREATE DATABASE ok;
USE ok;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50) COMMENT 'Имя',
    lastname VARCHAR(50) COMMENT 'Фамилия', 
    email VARCHAR(120) UNIQUE,
 	password_hash VARCHAR(100), 
	phone BIGINT UNSIGNED UNIQUE, 
	
    INDEX users_firstname_lastname_idx(firstname, lastname)
) COMMENT 'Пользователи';

DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	user_id BIGINT UNSIGNED NOT NULL UNIQUE,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100),
    
    INDEX profiles_hometown_idx(hometown),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL,
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),

    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS guests;
CREATE TABLE guests (
	id SERIAL,
	user_id BIGINT UNSIGNED NOT NULL,
    guest_user_id BIGINT UNSIGNED NOT NULL,
    visit_at DATETIME DEFAULT NOW(),

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (guest_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS friend_requests;
CREATE TABLE friend_requests (
	initiator_user_id BIGINT UNSIGNED NOT NULL,
    target_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('requested', 'approved', 'declined', 'unfriended'),
	requested_at DATETIME DEFAULT NOW(),
	updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
	
    PRIMARY KEY (initiator_user_id, target_user_id),
    FOREIGN KEY (initiator_user_id) REFERENCES users(id),
    FOREIGN KEY (target_user_id) REFERENCES users(id),
    CHECK (initiator_user_id <> target_user_id)
);

DROP TABLE IF EXISTS communities;
CREATE TABLE communities (
	id SERIAL,
	name VARCHAR(150),
	admin_user_id BIGINT UNSIGNED NOT NULL,
	
	INDEX communities_name_idx(name),
	FOREIGN KEY (admin_user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS users_communities;
CREATE TABLE users_communities (
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS frends;
CREATE TABLE frends (
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    frend_id BIGINT UNSIGNED NOT NULL,
    
    PRIMARY KEY (user_id, frend_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (frend_id) REFERENCES users(id)
) COMMENT 'Друзья';

DROP TABLE IF EXISTS giftstore;
CREATE TABLE giftstore (
	id SERIAL,
	giftname VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
) COMMENT 'Магазин подарочных открыток';

DROP TABLE IF EXISTS presents;
CREATE TABLE presents (
	id SERIAL,
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    present_id BIGINT UNSIGNED NOT NULL,
    status ENUM('sent', 'approved', 'declined'),
    sent_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id),
    FOREIGN KEY (present_id) REFERENCES giftstore(id)
) COMMENT 'Открытки к празднику';

DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types (
	id SERIAL,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media (
	id SERIAL,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body TEXT,
    filename VARCHAR(255),    	
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    created_at DATETIME DEFAULT NOW(),

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS comments;
CREATE TABLE comments (
	id SERIAL,
    user_id BIGINT UNSIGNED NOT NULL,
    media_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW(),
    
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

DROP TABLE IF EXISTS photo_albums;
CREATE TABLE photo_albums (
	id SERIAL,
	name VARCHAR(255) DEFAULT NULL,
    user_id BIGINT UNSIGNED DEFAULT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id),
  	PRIMARY KEY (id)
);

DROP TABLE IF EXISTS photos;
CREATE TABLE photos (
	id SERIAL,
	album_id BIGINT UNSIGNED NULL,
	media_id BIGINT UNSIGNED NOT NULL,

	FOREIGN KEY (album_id) REFERENCES photo_albums(id),
    FOREIGN KEY (media_id) REFERENCES media(id)
);

ALTER TABLE ok.profiles 
ADD CONSTRAINT profiles_fk_1 
FOREIGN KEY (photo_id) REFERENCES media(id);





