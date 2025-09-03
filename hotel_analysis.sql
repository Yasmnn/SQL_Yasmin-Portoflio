SELECT *
FROM projects.hotel_analysis;

-- BASIC - INTERMEDIATE ANALYSIS
-- 1.) What is the average overall score per year for each hotel_id?
SELECT hotel_id,
	EXTRACT(year FROM review_date) AS year,
	ROUND(AVG(score_overall),3) AS avg_overall_score
FROM projects.hotel_analysis
GROUP BY hotel_id, year
ORDER BY year DESC, avg_overall_score DESC;

-- 2.) Identify how many reviews each user_id has made over the entire period
SELECT user_id, COUNT (score_overall) AS count_review
FROM projects.hotel_analysis
GROUP BY user_id
ORDER BY user_id ASC;

-- 3.)Identify the users who most frequently give low overall scores
-- lets see the MIN and MAX number for overall score
SELECT MIN(score_overall), MAX(score_overall)
FROM projects.hotel_analysis;
-- It turns out that the minimum score is 8.2 and the maximum is 9.6
-- So i categorize the scores as follows:
-- a score of <= 8.5 is considered low, 8.6 to 8.9 is considered solid, and a score >= 9.0  is considered high
WITH user_score_category AS
	(SELECT user_id,
		CASE WHEN score_overall <= 8.5 THEN 'low'
		WHEN score_overall BETWEEN 8.6 AND 8.9 THEN 'solid'
		ELSE 'high' END AS score_category
	FROM projects.hotel_analysis)
SELECT user_id,
	COUNT(CASE WHEN score_category='low' THEN 1 END) AS low,
	COUNT(CASE WHEN score_category='solid' THEN 1 END) AS solid,
	COUNT(CASE WHEN score_category='high' THEN 1 END) AS high
FROM user_score_category
GROUP BY user_id
ORDER BY low DESC;
