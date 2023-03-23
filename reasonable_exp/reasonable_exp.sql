--
-- Reasonable EXP Curve
---

-- Pre Limit Break
-- 0-8 +250 EXP
-- 9-23 +200 EXP
-- 24-51 +100 EXP
-- 52-56 +200 EXP

-- Post Limit Break
-- 56-61 +1200 EXP
-- 62-70 +1500 EXP
-- 70-75 +2000 EXP

-- Correction
-- 56-61 +200 EXP
-- 62-70 +200 EXP
-- 70-75 +200 EXP

-- Current amount (Current total) >> (New total)
UPDATE `exp_base` SET exp =  8200 WHERE level = 53; --  9,200 (260,550) >> (259,550)
UPDATE `exp_base` SET exp =  8400 WHERE level = 54; -- 10,400 (270,950) >> (267,950)
UPDATE `exp_base` SET exp =  8600 WHERE level = 55; -- 11,600 (282,550) >> (276,550)
UPDATE `exp_base` SET exp =  8800 WHERE level = 56; -- 12,800 (295,350) >> (285,350)
UPDATE `exp_base` SET exp =  9000 WHERE level = 57; -- 14,000 (309,350) >> (294,350)
UPDATE `exp_base` SET exp =  9200 WHERE level = 58; -- 15,200 (324,550) >> (303,550)
UPDATE `exp_base` SET exp =  9400 WHERE level = 59; -- 16,400 (340,950) >> (312,950)
UPDATE `exp_base` SET exp =  9600 WHERE level = 60; -- 17,600 (358,550) >> (322,550)

UPDATE `exp_base` SET exp =  9800 WHERE level = 61; -- 18,800 (377,350) >> (332,350)
UPDATE `exp_base` SET exp = 10000 WHERE level = 62; -- 20,000 (397,350) >> (342,350)
UPDATE `exp_base` SET exp = 10200 WHERE level = 63; -- 21,500 (418,850) >> (352,550)
UPDATE `exp_base` SET exp = 10400 WHERE level = 64; -- 23,000 (441,850) >> (362,950)
UPDATE `exp_base` SET exp = 10600 WHERE level = 65; -- 24,500 (466,350) >> (373,550)
UPDATE `exp_base` SET exp = 10800 WHERE level = 66; -- 26,000 (492,350) >> (384,350)
UPDATE `exp_base` SET exp = 11000 WHERE level = 67; -- 27,500 (519,850) >> (395,350)
UPDATE `exp_base` SET exp = 11200 WHERE level = 68; -- 29,000 (548,850) >> (406,550)
UPDATE `exp_base` SET exp = 11400 WHERE level = 69; -- 30,500 (579,350) >> (417,950)
UPDATE `exp_base` SET exp = 11600 WHERE level = 70; -- 32,000 (611,350) >> (429,550)

UPDATE `exp_base` SET exp = 11800 WHERE level = 71; -- 34,000 (645,350) >> (441,350)
UPDATE `exp_base` SET exp = 12000 WHERE level = 72; -- 36,000 (681,350) >> (453,350)
UPDATE `exp_base` SET exp = 12200 WHERE level = 73; -- 38,000 (719,350) >> (465,550)
UPDATE `exp_base` SET exp = 12400 WHERE level = 74; -- 40,000 (759,350) >> (477,950)
UPDATE `exp_base` SET exp = 12600 WHERE level = 75; -- 42,000 (801,350) >> (490,550)
UPDATE `exp_base` SET exp = 12800 WHERE level = 76; -- 44,000 (845,350) >> (503,350)
