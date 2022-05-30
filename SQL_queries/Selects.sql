SELECT gender FROM (
	SELECT "m" as gender, COUNT(*) as total FROM likes WHERE user_id IN (SELECT user_id FROM profiles as p WHERE gender='m')
	UNION
	SELECT "f" as gender, COUNT(*) as total FROM likes WHERE user_id IN (SELECT user_id FROM profiles as p WHERE gender='f')
) as my_sort
ORDER BY total DESC
LIMIT 1;

SELECT count(*) messages, user FROM 
	(SELECT body, to_user_id AS user FROM messages WHERE from_user_id = 1
	 UNION
	 SELECT body, from_user_id AS user FROM messages WHERE to_user_id = 1) as history

GROUP BY user
ORDER BY messages DESC
LIMIT 1;


CREATE OR REPLACE VIEW user_friends
AS 
    SELECT *
    FROM users u
        JOIN friend_requests fr ON u.id = fr.target_user_id
    WHERE 
    fr.status = 'approved'
        UNION
    SELECT *
    FROM users u 
        JOIN friend_requests fr ON u.id = fr.initiator_user_id
    WHERE fr.status = 'approved';


CREATE OR REPLACE VIEW user_activity
AS
    SELECT u.lastname
    FROM users u
        INNER JOIN likes AS l ON (l.user_id = u.id)
    GROUP BY u.lastname
    HAVING COUNT(l.id) > 0;


DROP PROCEDURE IF EXISTS fr_offers;

DELIMITER //
CREATE PROCEDURE fr_offers(IN for_user_id INT)
    BEGIN 
	    SELECT p2.user_id
	    FROM profiles p1
	    JOIN profiles p2
	        ON p1.hometown = p2.hometown
	    WHERE p1.user_id = for_user_id
	        AND p2.user_id <> for_user_id
	            UNION 
	    SELECT uc2.user_id
	    FROM users_communities uc1
	    JOIN users_communities uc2
	        ON uc1.community_id = uc2.community_id 
	    WHERE uc1.user_id = for_user_id 
	        AND uc2.user_id <> for_user_id
	            UNION
	    SELECT fr3.target_user_id
	    FROM friend_requests fr1
	        JOIN friend_requests fr2
	            ON (fr1.target_user_id = fr2.initiator_user_id
	                OR fr1.initiator_user_id = fr2.target_user_id)
	        JOIN friend_requests fr3
	            ON (fr3.target_user_id = fr2.initiator_user_id
	                OR fr3.initiator_user_id = fr2.target_user_id)
	    WHERE (fr1.initiator_user_id = for_user_id OR fr1.target_user_id = for_user_id)
	            AND fr2.status = 'approved'
	            AND fr3.status = 'approved'
	            AND fr3.target_user_id <> for_user_id
	    ORDER BY rand()
	    LIMIT 2;            
    END//
DELIMITER ;





























