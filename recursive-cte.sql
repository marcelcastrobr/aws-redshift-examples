CREATE TABLE groups (id INT IDENTITY(1, 1), name character varying NOT NULL);
CREATE TABLE network_group_members (pid integer, cid integer NOT NULL);
INSERT INTO groups (name) VALUES ('GROUP 1'),('GROUP 2'),('GROUP 3'),('GROUP 4'),('GROUP 5'),('GROUP 6'),('GROUP 7'),('GROUP 8'),('GROUP 9'),('GROUP 10'),('GROUP 11'),('GROUP 12'),('GROUP 13');
INSERT INTO network_group_members(pid,cid) VALUES (1,2),(1,3),(1,4),(2,5),(5,6),(5,7),(7,8),(3,9),(4,10),(4,11),(11,12),(12,13);
select * from network_group_members
select * from groups

WITH RECURSIVE nodes(pid, parentName, cid, childName, path, depth) AS (
    SELECT
        r."pid", p1."name",
        r."cid", p2."name",
        ARRAY(r."pid"),
        1
    FROM "network_group_members" AS r, "groups" AS p1, "groups" AS p2
    WHERE
      -- change r.pid = 1 to the root node id that you want to query the tree from
            r."pid" = 1 AND
            p1."id" = r."pid"
      AND p2."id" = r."cid"
    UNION ALL
    SELECT
        r."pid",
        p1."name",
        r."cid",
        p2."name",
        --path || r."pid",
        ARRAY_CONCAT(path, ARRAY(r."pid")),
        nd.depth + 1
    FROM "network_group_members" AS r, "groups" AS p1, "groups" AS p2, nodes AS nd
    WHERE
            r."pid" = nd.cid AND
            p1."id" = r."pid" AND
            p2."id" = r."cid"
    -- To query all descendant nodes within a specific depth level, uncomment the next line
    -- AND depth < 2
)
SELECT * FROM nodes;