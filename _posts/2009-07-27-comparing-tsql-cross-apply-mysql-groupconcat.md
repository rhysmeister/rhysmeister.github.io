---
layout: post
title: Comparing T-SQL Cross Apply with MySQL GROUP_CONCAT
date: 2009-07-27 15:00:00.000000000 +02:00
type: post
parent_id: '0'
published: true
password: ''
status: publish
categories:
- MySQL
- T-SQL
tags:
- MySQL
- TSQL
meta:
  _edit_last: '1'
  twittercomments: a:0:{}
  tweetcount: '0'
  tweetbackscheck: '1613469761'
  shorturls: a:7:{s:9:"permalink";s:82:"http://www.youdidwhatwithtsql.com/comparing-tsql-cross-apply-mysql-groupconcat/280";s:7:"tinyurl";s:25:"http://tinyurl.com/ndg9v9";s:4:"isgd";s:18:"http://is.gd/1PjBL";s:5:"bitly";s:19:"http://bit.ly/CIjVm";s:5:"snipr";s:22:"http://snipr.com/o2xp4";s:5:"snurl";s:22:"http://snurl.com/o2xp4";s:7:"snipurl";s:24:"http://snipurl.com/o2xp4";}
author:
  login: admin
  email: therhysmeister@hotmail.com
  display_name: Rhys
  first_name: ''
  last_name: ''
permalink: "/comparing-tsql-cross-apply-mysql-groupconcat/280/"
---
[Steve Novoselac](http://blog.stevienova.com) posted a good article about [using CROSS APPLY](http://blog.stevienova.com/2009/07/15/t-sql-using-cross-apply-to-turn-2-queries-into-1/) with TSQL. This is a really useful technique for transforming data into grouped lists. It made me think of a similar feature in [MySQL](http://www.mysql.com), a function, called [GROUP\_CONCAT](http://dev.mysql.com/doc/refman/5.1/en/group-by-functions.html#function_group-concat). Here’s a demonstration of [CROSS APPLY](http://technet.microsoft.com/en-us/library/ms175156.aspx) with TSQL and [GROUP\_CONCAT](http://dev.mysql.com/doc/refman/5.1/en/group-by-functions.html#function_group-concat) in [MySQL](http://www.mysql.com) to achieve the same thing. I’m going to use the example of continents and their member countries.

First create the follow table structure in SQL Server.

```
CREATE TABLE [dbo].[geonames](
	[ISO] [varchar](5) NOT NULL,
	[ISO3] [varchar](3) NULL,
	[ISO-Numeric] [smallint] NULL,
	[fips] [varchar](2) NULL,
	[Country] [varchar](44) NULL,
	[Capital] [varchar](20) NULL,
	[Area(in sq km)] [real] NULL,
	[Population] [int] NULL,
	[Continent] [varchar](2) NULL,
	[tld] [varchar](3) NULL,
	[CurrencyCode] [varchar](3) NULL,
	[CurrencyName] [varchar](13) NULL,
	[Phone] [varchar](16) NULL,
	[Postal Code Format] [varchar](55) NULL,
	[Postal Code Regex] [varchar](155) NULL,
	[Languages] [varchar](56) NULL,
	[geonameid] [int] NULL,
	[neighbours] [varchar](41) NULL,
	[EquivalentFipsCode] [varchar](2) NULL,
 CONSTRAINT [PK_ISO] PRIMARY KEY CLUSTERED
(
	[ISO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
```

The add this data (it scrolls quite a way). N.B. The data here has been taken from the [GeoNames](http://www.geonames.org/export/) project.

```
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[geonames]([ISO], [ISO3], [ISO-Numeric], [fips], [Country], [Capital], [Area(in sq km)], [Population], [Continent], [tld], [CurrencyCode], [CurrencyName], [Phone], [Postal Code Format], [Postal Code Regex], [Languages], [geonameid], [neighbours], [EquivalentFipsCode])
SELECT N'AD', N'AND', 20, N'AN', N'Andorra', N'Andorra la Vella', N'468', 72000, N'EU', N'.ad', N'EUR', N'Euro', N'376', N'AD###', N'^(?:AD)*(\d{3})$', N'ca,fr-AD,pt', 3041565, N'ES,FR', N'' UNION ALL
SELECT N'AE', N'ARE', 784, N'AE', N'United Arab Emirates', N'Abu Dhabi', N'82880', 4621000, N'AS', N'.ae', N'AED', N'Dirham', N'971', N'', N'', N'ar-AE,fa,en,hi,ur', 290557, N'SA,OM', N'' UNION ALL
SELECT N'AF', N'AFG', 4, N'AF', N'Afghanistan', N'Kabul', N'647500', 32738000, N'AS', N'.af', N'AFN', N'Afghani', N'93', N'', N'', N'fa-AF,ps,uz-AF,tk', 1149361, N'TM,CN,IR,TJ,PK,UZ', N'' UNION ALL
SELECT N'AG', N'ATG', 28, N'AC', N'Antigua and Barbuda', N'St. John''s', N'443', 69000, N'NA', N'.ag', N'XCD', N'Dollar', N'-267', N'', N'', N'en-AG', 3576396, N'', N'' UNION ALL
SELECT N'AI', N'AIA', 660, N'AV', N'Anguilla', N'The Valley', N'102', 13254, N'NA', N'.ai', N'XCD', N'Dollar', N'-263', N'', N'', N'en-AI', 3573511, N'', N'' UNION ALL
SELECT N'AL', N'ALB', 8, N'AL', N'Albania', N'Tirana', N'28748', 3619000, N'EU', N'.al', N'ALL', N'Lek', N'355', N'', N'', N'sq,el', 783754, N'MK,GR,CS,ME,RS', N'' UNION ALL
SELECT N'AM', N'ARM', 51, N'AM', N'Armenia', N'Yerevan', N'29800', 2968000, N'AS', N'.am', N'AMD', N'Dram', N'374', N'######', N'^(\d{6})$', N'hy', 174982, N'GE,IR,AZ,TR', N'' UNION ALL
SELECT N'AN', N'ANT', 530, N'NT', N'Netherlands Antilles', N'Willemstad', N'960', 136197, N'NA', N'.an', N'ANG', N'Guilder', N'599', N'', N'', N'nl-AN,en,es', 3513447, N'GP', N'' UNION ALL
SELECT N'AO', N'AGO', 24, N'AO', N'Angola', N'Luanda', N'1246700', 12531000, N'AF', N'.ao', N'AOA', N'Kwanza', N'244', N'', N'', N'pt-AO', 3351879, N'CD,NA,ZM,CG', N'' UNION ALL
SELECT N'AQ', N'ATA', 10, N'AY', N'Antarctica', N'', N'1.4E+07', 0, N'AN', N'.aq', N'', N'', N'', N'', N'', N'', 6697173, N'', N'' UNION ALL
SELECT N'AR', N'ARG', 32, N'AR', N'Argentina', N'Buenos Aires', N'2766890', 40677000, N'SA', N'.ar', N'ARS', N'Peso', N'54', N'@####@@@', N'^([A-Z]\d{4}[A-Z]{3})$', N'es-AR,en,it,de,fr', 3865483, N'CL,BO,UY,PY,BR', N'' UNION ALL
SELECT N'AS', N'ASM', 16, N'AQ', N'American Samoa', N'Pago Pago', N'199', 57881, N'OC', N'.as', N'USD', N'Dollar', N'-683', N'', N'', N'en-AS,sm,to', 5880801, N'', N'' UNION ALL
SELECT N'AT', N'AUT', 40, N'AU', N'Austria', N'Vienna', N'83858', 8205000, N'EU', N'.at', N'EUR', N'Euro', N'43', N'####', N'^(\d{4})$', N'de-AT,hr,hu,sl', 2782113, N'CH,DE,HU,SK,CZ,IT,SI,LI', N'' UNION ALL
SELECT N'AU', N'AUS', 36, N'AS', N'Australia', N'Canberra', N'7686850', 20600000, N'OC', N'.au', N'AUD', N'Dollar', N'61', N'####', N'^(\d{4})$', N'en-AU', 2077456, N'', N'' UNION ALL
SELECT N'AW', N'ABW', 533, N'AA', N'Aruba', N'Oranjestad', N'193', 71566, N'NA', N'.aw', N'AWG', N'Guilder', N'297', N'', N'', N'nl-AW,es,en', 3577279, N'', N'' UNION ALL
SELECT N'AX', N'ALA', 248, N'', N'Aland Islands', N'Mariehamn', N'0', 26711, N'EU', N'.ax', N'EUR', N'Euro', N'340', N'', N'', N'sv-AX', 661882, N'', N'FI' UNION ALL
SELECT N'AZ', N'AZE', 31, N'AJ', N'Azerbaijan', N'Baku', N'86600', 8177000, N'AS', N'.az', N'AZN', N'Manat', N'994', N'AZ ####', N'^(?:AZ)*(\d{4})$', N'az,ru,hy', 587116, N'GE,IR,AM,TR,RU', N'' UNION ALL
SELECT N'BA', N'BIH', 70, N'BK', N'Bosnia and Herzegovina', N'Sarajevo', N'51129', 4590000, N'EU', N'.ba', N'BAM', N'Marka', N'387', N'#####', N'^(\d{5})$', N'bs,hr-BA,sr-BA', 3277605, N'CS,HR,ME,RS', N'' UNION ALL
SELECT N'BB', N'BRB', 52, N'BB', N'Barbados', N'Bridgetown', N'431', 281000, N'NA', N'.bb', N'BBD', N'Dollar', N'-245', N'BB#####', N'^(?:BB)*(\d{5})$', N'en-BB', 3374084, N'', N'' UNION ALL
SELECT N'BD', N'BGD', 50, N'BG', N'Bangladesh', N'Dhaka', N'144000', 153546000, N'AS', N'.bd', N'BDT', N'Taka', N'880', N'####', N'^(\d{4})$', N'bn-BD,en', 1210997, N'MM,IN', N'' UNION ALL
SELECT N'BE', N'BEL', 56, N'BE', N'Belgium', N'Brussels', N'30510', 10403000, N'EU', N'.be', N'EUR', N'Euro', N'32', N'####', N'^(\d{4})$', N'nl-BE,fr-BE,de-BE', 2802361, N'DE,NL,LU,FR', N'' UNION ALL
SELECT N'BF', N'BFA', 854, N'UV', N'Burkina Faso', N'Ouagadougou', N'274200', 14761000, N'AF', N'.bf', N'XOF', N'Franc', N'226', N'', N'', N'fr-BF', 2361809, N'NE,BJ,GH,CI,TG,ML', N'' UNION ALL
SELECT N'BG', N'BGR', 100, N'BU', N'Bulgaria', N'Sofia', N'110910', 7262000, N'EU', N'.bg', N'BGN', N'Lev', N'359', N'####', N'^(\d{4})$', N'bg,tr-BG', 732800, N'MK,GR,RO,CS,TR,RS', N'' UNION ALL
SELECT N'BH', N'BHR', 48, N'BA', N'Bahrain', N'Manama', N'665', 718000, N'AS', N'.bh', N'BHD', N'Dinar', N'973', N'####|###', N'^(\d{3}\d?)$', N'ar-BH,en,fa,ur', 290291, N'', N'' UNION ALL
SELECT N'BI', N'BDI', 108, N'BY', N'Burundi', N'Bujumbura', N'27830', 8691000, N'AF', N'.bi', N'BIF', N'Franc', N'257', N'', N'', N'fr-BI,rn', 433561, N'TZ,CD,RW', N'' UNION ALL
SELECT N'BJ', N'BEN', 204, N'BN', N'Benin', N'Porto-Novo', N'112620', 8294000, N'AF', N'.bj', N'XOF', N'Franc', N'229', N'', N'', N'fr-BJ', 2395170, N'NE,TG,BF,NG', N'' UNION ALL
SELECT N'BL', N'BLM', 652, N'TB', N'Saint Barthélemy', N'Gustavia', N'21', 8450, N'NA', N'.gp', N'EUR', N'Euro', N'590', N'### ###', N'', N'fr', 3578476, N'', N'' UNION ALL
SELECT N'BM', N'BMU', 60, N'BD', N'Bermuda', N'Hamilton', N'53', 65365, N'NA', N'.bm', N'BMD', N'Dollar', N'-440', N'@@ ##', N'^([A-Z]{2}\d{2})$', N'en-BM,pt', 3573345, N'', N'' UNION ALL
SELECT N'BN', N'BRN', 96, N'BX', N'Brunei', N'Bandar Seri Begawan', N'5770', 381000, N'AS', N'.bn', N'BND', N'Dollar', N'673', N'@@####', N'^([A-Z]{2}\d{4})$', N'ms-BN,en-BN', 1820814, N'MY', N'' UNION ALL
SELECT N'BO', N'BOL', 68, N'BL', N'Bolivia', N'La Paz', N'1098580', 9247000, N'SA', N'.bo', N'BOB', N'Boliviano', N'591', N'', N'', N'es-BO,qu,ay', 3923057, N'PE,CL,PY,BR,AR', N'' UNION ALL
SELECT N'BR', N'BRA', 76, N'BR', N'Brazil', N'Brasília', N'8511965', 191908000, N'SA', N'.br', N'BRL', N'Real', N'55', N'#####-###', N'^(\d{8})$', N'pt-BRR,es,en,fr', 3469034, N'SR,PE,BO,UY,GY,PY,GF,VE,CO,AR', N'' UNION ALL
SELECT N'BS', N'BHS', 44, N'BF', N'Bahamas', N'Nassau', N'13940', 301790, N'NA', N'.bs', N'BSD', N'Dollar', N'-241', N'', N'', N'en-BS', 3572887, N'', N'' UNION ALL
SELECT N'BT', N'BTN', 64, N'BT', N'Bhutan', N'Thimphu', N'47000', 2376000, N'AS', N'.bt', N'BTN', N'Ngultrum', N'975', N'', N'', N'dz', 1252634, N'CN,IN', N'' UNION ALL
SELECT N'BV', N'BVT', 74, N'BV', N'Bouvet Island', N'', N'0', 0, N'AN', N'.bv', N'NOK', N'Krone', N'', N'', N'', N'', 3371123, N'', N'' UNION ALL
SELECT N'BW', N'BWA', 72, N'BC', N'Botswana', N'Gaborone', N'600370', 1842000, N'AF', N'.bw', N'BWP', N'Pula', N'267', N'', N'', N'en-BW,tn-BW', 933860, N'ZW,ZA,NA', N'' UNION ALL
SELECT N'BY', N'BLR', 112, N'BO', N'Belarus', N'Minsk', N'207600', 9685000, N'EU', N'.by', N'BYR', N'Ruble', N'375', N'######', N'^(\d{6})$', N'be,ru', 630336, N'PL,LT,UA,RU,LV', N'' UNION ALL
SELECT N'BZ', N'BLZ', 84, N'BH', N'Belize', N'Belmopan', N'22966', 301000, N'NA', N'.bz', N'BZD', N'Dollar', N'501', N'', N'', N'en-BZ,es', 3582678, N'GT,MX', N'' UNION ALL
SELECT N'CA', N'CAN', 124, N'CA', N'Canada', N'Ottawa', N'9984670', 33679000, N'NA', N'.ca', N'CAD', N'Dollar', N'1', N'@#@ #@#', N'^([a-zA-Z]\d[a-zA-Z]\d[a-zA-Z]\d)$', N'en-CA,fr-CA', 6251999, N'US', N'' UNION ALL
SELECT N'CC', N'CCK', 166, N'CK', N'Cocos Islands', N'West Island', N'14', 628, N'AS', N'.cc', N'AUD', N'Dollar', N'61', N'', N'', N'ms-CC,en', 1547376, N'', N'' UNION ALL
SELECT N'CD', N'COD', 180, N'CG', N'Democratic Republic of the Congo', N'Kinshasa', N'2345410', 60085004, N'AF', N'.cd', N'CDF', N'Franc', N'243', N'', N'', N'fr-CD,ln,kg', 203312, N'TZ,CF,SD,RW,ZM,BI,UG,CG,AO', N'' UNION ALL
SELECT N'CF', N'CAF', 140, N'CT', N'Central African Republic', N'Bangui', N'622984', 4434000, N'AF', N'.cf', N'XAF', N'Franc', N'236', N'', N'', N'fr-CF,ln,kg', 239880, N'TD,SD,CD,CM,CG', N'' UNION ALL
SELECT N'CG', N'COG', 178, N'CF', N'Republic of the Congo', N'Brazzaville', N'342000', 3039126, N'AF', N'.cg', N'XAF', N'Franc', N'242', N'', N'', N'fr-CG,kg,ln-CG', 2260494, N'CF,GA,CD,CM,AO', N'' UNION ALL
SELECT N'CH', N'CHE', 756, N'SZ', N'Switzerland', N'Berne', N'41290', 7581000, N'EU', N'.ch', N'CHF', N'Franc', N'41', N'####', N'^(\d{4})$', N'de-CH,fr-CH,it-CH,rm', 2658434, N'DE,IT,LI,FR,AT', N'' UNION ALL
SELECT N'CI', N'CIV', 384, N'IV', N'Ivory Coast', N'Yamoussoukro', N'322460', 18373000, N'AF', N'.ci', N'XOF', N'Franc', N'225', N'', N'', N'fr-CI', 2287781, N'LR,GH,GN,BF,ML', N'' UNION ALL
SELECT N'CK', N'COK', 184, N'CW', N'Cook Islands', N'Avarua', N'240', 21388, N'OC', N'.ck', N'NZD', N'Dollar', N'682', N'', N'', N'en-CK,mi', 1899402, N'', N'' UNION ALL
SELECT N'CL', N'CHL', 152, N'CI', N'Chile', N'Santiago', N'756950', 16432000, N'SA', N'.cl', N'CLP', N'Peso', N'56', N'#######', N'^(\d{7})$', N'es-CL', 3895114, N'PE,BO,AR', N'' UNION ALL
SELECT N'CM', N'CMR', 120, N'CM', N'Cameroon', N'Yaoundé', N'475440', 18467000, N'AF', N'.cm', N'XAF', N'Franc', N'237', N'', N'', N'en-CM,fr-CM', 2233387, N'TD,CF,GA,GQ,CG,NG', N'' UNION ALL
SELECT N'CN', N'CHN', 156, N'CH', N'China', N'Beijing', N'9596960', 1330044000, N'AS', N'.cn', N'CNY', N'Yuan Renminbi', N'86', N'######', N'^(\d{6})$', N'zh-CN,yue,wuu', 1814991, N'LA,BT,TJ,KZ,MN,AF,NP,MM,KG,PK,KP,RU,VN,IN', N'' UNION ALL
SELECT N'CO', N'COL', 170, N'CO', N'Colombia', N'Bogotá', N'1138910', 45013000, N'SA', N'.co', N'COP', N'Peso', N'57', N'', N'', N'es-CO', 3686110, N'EC,PE,PA,BR,VE', N'' UNION ALL
SELECT N'CR', N'CRI', 188, N'CS', N'Costa Rica', N'San José', N'51100', 4191000, N'NA', N'.cr', N'CRC', N'Colon', N'506', N'####', N'^(\d{4})$', N'es-CR,en', 3624060, N'PA,NI', N''
COMMIT;
RAISERROR (N'[dbo].[geonames]: Insert Batch: 1.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[geonames]([ISO], [ISO3], [ISO-Numeric], [fips], [Country], [Capital], [Area(in sq km)], [Population], [Continent], [tld], [CurrencyCode], [CurrencyName], [Phone], [Postal Code Format], [Postal Code Regex], [Languages], [geonameid], [neighbours], [EquivalentFipsCode])
SELECT N'CS', N'SCG', 891, N'YI', N'Serbia and Montenegro', N'Belgrade', N'102350', 10829175, N'EU', N'.cs', N'RSD', N'Dinar', N'381', N'#####', N'^(\d{5})$', N'cu,hu,sq,sr', 863038, N'AL,HU,MK,RO,HR,BA,BG', N'' UNION ALL
SELECT N'CU', N'CUB', 192, N'CU', N'Cuba', N'Havana', N'110860', 11423000, N'NA', N'.cu', N'CUP', N'Peso', N'53', N'CP #####', N'^(?:CP)*(\d{5})$', N'es-CU', 3562981, N'US', N'' UNION ALL
SELECT N'CV', N'CPV', 132, N'CV', N'Cape Verde', N'Praia', N'4033', 426000, N'AF', N'.cv', N'CVE', N'Escudo', N'238', N'####', N'^(\d{4})$', N'pt-CV', 3374766, N'', N'' UNION ALL
SELECT N'CX', N'CXR', 162, N'KT', N'Christmas Island', N'Flying Fish Cove', N'135', 361, N'AS', N'.cx', N'AUD', N'Dollar', N'61', N'####', N'^(\d{4})$', N'en,zh,ms-CC', 2078138, N'', N'' UNION ALL
SELECT N'CY', N'CYP', 196, N'CY', N'Cyprus', N'Nicosia', N'9250', 792000, N'EU', N'.cy', N'EUR', N'Euro', N'357', N'####', N'^(\d{4})$', N'el-CY,tr-CY,en', 146669, N'', N'' UNION ALL
SELECT N'CZ', N'CZE', 203, N'EZ', N'Czech Republic', N'Prague', N'78866', 10220000, N'EU', N'.cz', N'CZK', N'Koruna', N'420', N'### ##', N'^(\d{5})$', N'cs,sk', 3077311, N'PL,DE,SK,AT', N'' UNION ALL
SELECT N'DE', N'DEU', 276, N'GM', N'Germany', N'Berlin', N'357021', 82369000, N'EU', N'.de', N'EUR', N'Euro', N'49', N'#####', N'^(\d{5})$', N'de', 2921044, N'CH,PL,NL,DK,BE,CZ,LU,FR,AT', N'' UNION ALL
SELECT N'DJ', N'DJI', 262, N'DJ', N'Djibouti', N'Djibouti', N'23000', 506000, N'AF', N'.dj', N'DJF', N'Franc', N'253', N'', N'', N'fr-DJ,ar,so-DJ,aa', 223816, N'ER,ET,SO', N'' UNION ALL
SELECT N'DK', N'DNK', 208, N'DA', N'Denmark', N'Copenhagen', N'43094', 5484000, N'EU', N'.dk', N'DKK', N'Krone', N'45', N'####', N'^(\d{4})$', N'da-DK,en,fo,de-DK', 2623032, N'DE', N'' UNION ALL
SELECT N'DM', N'DMA', 212, N'DO', N'Dominica', N'Roseau', N'754', 72000, N'NA', N'.dm', N'XCD', N'Dollar', N'-766', N'', N'', N'en-DM', 3575830, N'', N'' UNION ALL
SELECT N'DO', N'DOM', 214, N'DR', N'Dominican Republic', N'Santo Domingo', N'48730', 9507000, N'NA', N'.do', N'DOP', N'Peso', N'+1-809 and 1-829', N'#####', N'^(\d{5})$', N'es-DO', 3508796, N'HT', N'' UNION ALL
SELECT N'DZ', N'DZA', 12, N'AG', N'Algeria', N'Algiers', N'2381740', 33739000, N'AF', N'.dz', N'DZD', N'Dinar', N'213', N'#####', N'^(\d{5})$', N'ar-DZ', 2589581, N'NE,EH,LY,MR,TN,MA,ML', N'' UNION ALL
SELECT N'EC', N'ECU', 218, N'EC', N'Ecuador', N'Quito', N'283560', 13927000, N'SA', N'.ec', N'USD', N'Dollar', N'593', N'@####@', N'^([a-zA-Z]\d{4}[a-zA-Z])$', N'es-EC', 3658394, N'PE,CO', N'' UNION ALL
SELECT N'EE', N'EST', 233, N'EN', N'Estonia', N'Tallinn', N'45226', 1307000, N'EU', N'.ee', N'EEK', N'Kroon', N'372', N'#####', N'^(\d{5})$', N'et,ru', 453733, N'RU,LV', N'' UNION ALL
SELECT N'EG', N'EGY', 818, N'EG', N'Egypt', N'Cairo', N'1001450', 81713000, N'AF', N'.eg', N'EGP', N'Pound', N'20', N'#####', N'^(\d{5})$', N'ar-EG,en,fr', 357994, N'LY,SD,IL', N'' UNION ALL
SELECT N'EH', N'ESH', 732, N'WI', N'Western Sahara', N'El-Aaiun', N'266000', 273008, N'AF', N'.eh', N'MAD', N'Dirham', N'212', N'', N'', N'ar,mey', 2461445, N'DZ,MR,MA', N'' UNION ALL
SELECT N'ER', N'ERI', 232, N'ER', N'Eritrea', N'Asmara', N'121320', 5028000, N'AF', N'.er', N'ERN', N'Nakfa', N'291', N'', N'', N'aa-ER,ar,tig,kun,ti-ER', 338010, N'ET,SD,DJ', N'' UNION ALL
SELECT N'ES', N'ESP', 724, N'SP', N'Spain', N'Madrid', N'504782', 40491000, N'EU', N'.es', N'EUR', N'Euro', N'34', N'#####', N'^(\d{5})$', N'es-ES,ca,gl,eu', 2510769, N'AD,PT,GI,FR,MA', N'' UNION ALL
SELECT N'ET', N'ETH', 231, N'ET', N'Ethiopia', N'Addis Ababa', N'1127127', 78254000, N'AF', N'.et', N'ETB', N'Birr', N'251', N'####', N'^(\d{4})$', N'am,en-ET,om-ET,ti-ET,so-ET,sid', 337996, N'ER,KE,SD,SO,DJ', N'' UNION ALL
SELECT N'FI', N'FIN', 246, N'FI', N'Finland', N'Helsinki', N'337030', 5244000, N'EU', N'.fi', N'EUR', N'Euro', N'358', N'FI-#####', N'^(?:FI)*(\d{5})$', N'fi-FI,sv-FI,smn', 660013, N'NO,RU,SE', N'' UNION ALL
SELECT N'FJ', N'FJI', 242, N'FJ', N'Fiji', N'Suva', N'18270', 931000, N'OC', N'.fj', N'FJD', N'Dollar', N'679', N'', N'', N'en-FJ,fj', 2205218, N'', N'' UNION ALL
SELECT N'FK', N'FLK', 238, N'FK', N'Falkland Islands', N'Stanley', N'12173', 2638, N'SA', N'.fk', N'FKP', N'Pound', N'500', N'', N'', N'en-FK', 3474414, N'', N'' UNION ALL
SELECT N'FM', N'FSM', 583, N'FM', N'Micronesia', N'Palikir', N'702', 108105, N'OC', N'.fm', N'USD', N'Dollar', N'691', N'#####', N'^(\d{5})$', N'en-FM,chk,pon,yap,kos,uli,woe,nkr,kpg', 2081918, N'', N'' UNION ALL
SELECT N'FO', N'FRO', 234, N'FO', N'Faroe Islands', N'Tórshavn', N'1399', 48228, N'EU', N'.fo', N'DKK', N'Krone', N'298', N'FO-###', N'^(?:FO)*(\d{3})$', N'fo,da-FO', 2622320, N'', N'' UNION ALL
SELECT N'FR', N'FRA', 250, N'FR', N'France', N'Paris', N'547030', 64094000, N'EU', N'.fr', N'EUR', N'Euro', N'33', N'#####', N'^(\d{5})$', N'fr-FR,frp,br,co,ca,eu', 3017382, N'CH,DE,BE,LU,IT,AD,MC,ES', N'' UNION ALL
SELECT N'GA', N'GAB', 266, N'GB', N'Gabon', N'Libreville', N'267667', 1484000, N'AF', N'.ga', N'XAF', N'Franc', N'241', N'', N'', N'fr-GA', 2400553, N'CM,GQ,CG', N'' UNION ALL
SELECT N'GB', N'GBR', 826, N'UK', N'United Kingdom', N'London', N'244820', 60943000, N'EU', N'.uk', N'GBP', N'Pound', N'44', N'@# #@@|@## #@@|@@# #@@|@@## #@@|@#@ #@@|@@#@ #@@|GIR0AA', N'^(([A-Z]\d{2}[A-Z]{2})|([A-Z]\d{3}[A-Z]{2})|([A-Z]{2}\d{2}[A-Z]{2})|([A-Z]{2}\d{3}[A-Z]{2})|([A-Z]\d[A-Z]\d[A-Z]{2})|([A-Z]{2}\d[A-Z]\d[A-Z]{2})|(GIR0AA))$', N'en-GB,cy-GB,gd', 2635167, N'IE', N'' UNION ALL
SELECT N'GD', N'GRD', 308, N'GJ', N'Grenada', N'St. George''s', N'344', 90000, N'NA', N'.gd', N'XCD', N'Dollar', N'-472', N'', N'', N'en-GD', 3580239, N'', N'' UNION ALL
SELECT N'GE', N'GEO', 268, N'GG', N'Georgia', N'Tbilisi', N'69700', 4630000, N'AS', N'.ge', N'GEL', N'Lari', N'995', N'####', N'^(\d{4})$', N'ka,ru,hy,az', 614540, N'AM,AZ,TR,RU', N'' UNION ALL
SELECT N'GF', N'GUF', 254, N'FG', N'French Guiana', N'Cayenne', N'91000', 195506, N'SA', N'.gf', N'EUR', N'Euro', N'594', N'#####', N'^((97)|(98)3\d{2})$', N'fr-GF', 3381670, N'SR,BR', N'' UNION ALL
SELECT N'GG', N'GGY', 831, N'GK', N'Guernsey', N'St Peter Port', N'78', 65228, N'EU', N'.gg', N'GBP', N'Pound', N'-1437', N'@# #@@|@## #@@|@@# #@@|@@## #@@|@#@ #@@|@@#@ #@@|GIR0AA', N'^(([A-Z]\d{2}[A-Z]{2})|([A-Z]\d{3}[A-Z]{2})|([A-Z]{2}\d{2}[A-Z]{2})|([A-Z]{2}\d{3}[A-Z]{2})|([A-Z]\d[A-Z]\d[A-Z]{2})|([A-Z]{2}\d[A-Z]\d[A-Z]{2})|(GIR0AA))$', N'en,fr', 3042362, N'', N'' UNION ALL
SELECT N'GH', N'GHA', 288, N'GH', N'Ghana', N'Accra', N'239460', 23382000, N'AF', N'.gh', N'GHS', N'Cedi', N'233', N'', N'', N'en-GH,ak,ee,tw', 2300660, N'CI,TG,BF', N'' UNION ALL
SELECT N'GI', N'GIB', 292, N'GI', N'Gibraltar', N'Gibraltar', N'6.5', 27884, N'EU', N'.gi', N'GIP', N'Pound', N'350', N'', N'', N'en-GI,es,it,pt', 2411586, N'ES', N'' UNION ALL
SELECT N'GL', N'GRL', 304, N'GL', N'Greenland', N'Nuuk', N'2166086', 56375, N'NA', N'.gl', N'DKK', N'Krone', N'299', N'####', N'^(\d{4})$', N'kl,da-GL,en', 3425505, N'', N'' UNION ALL
SELECT N'GM', N'GMB', 270, N'GA', N'Gambia', N'Banjul', N'11300', 1593256, N'AF', N'.gm', N'GMD', N'Dalasi', N'220', N'', N'', N'en-GM,mnk,wof,wo,ff', 2413451, N'SN', N'' UNION ALL
SELECT N'GN', N'GIN', 324, N'GV', N'Guinea', N'Conakry', N'245857', 10211000, N'AF', N'.gn', N'GNF', N'Franc', N'224', N'', N'', N'fr-GN', 2420477, N'LR,SN,SL,CI,GW,ML', N'' UNION ALL
SELECT N'GP', N'GLP', 312, N'GP', N'Guadeloupe', N'Basse-Terre', N'1780', 443000, N'NA', N'.gp', N'EUR', N'Euro', N'590', N'#####', N'^((97)|(98)\d{3})$', N'fr-GP', 3579143, N'AN', N'' UNION ALL
SELECT N'GQ', N'GNQ', 226, N'EK', N'Equatorial Guinea', N'Malabo', N'28051', 562000, N'AF', N'.gq', N'XAF', N'Franc', N'240', N'', N'', N'es-GQ,fr', 2309096, N'GA,CM', N'' UNION ALL
SELECT N'GR', N'GRC', 300, N'GR', N'Greece', N'Athens', N'131940', 10722000, N'EU', N'.gr', N'EUR', N'Euro', N'30', N'### ##', N'^(\d{5})$', N'el-GR,en,fr', 390903, N'AL,MK,TR,BG', N'' UNION ALL
SELECT N'GS', N'SGS', 239, N'SX', N'South Georgia and the South Sandwich Islands', N'Grytviken', N'3903', 100, N'AN', N'.gs', N'GBP', N'Pound', N'', N'', N'', N'en', 3474415, N'', N'' UNION ALL
SELECT N'GT', N'GTM', 320, N'GT', N'Guatemala', N'Guatemala City', N'108890', 13002000, N'NA', N'.gt', N'GTQ', N'Quetzal', N'502', N'#####', N'^(\d{5})$', N'es-GT', 3595528, N'MX,HN,BZ,SV', N'' UNION ALL
SELECT N'GU', N'GUM', 316, N'GQ', N'Guam', N'Hagåtña', N'549', 168564, N'OC', N'.gu', N'USD', N'Dollar', N'-670', N'969##', N'^(969\d{2})$', N'en-GU,ch-GU', 4043988, N'', N'' UNION ALL
SELECT N'GW', N'GNB', 624, N'PU', N'Guinea-Bissau', N'Bissau', N'36120', 1503000, N'AF', N'.gw', N'XOF', N'Franc', N'245', N'####', N'^(\d{4})$', N'pt-GW,pov', 2372248, N'SN,GN', N'' UNION ALL
SELECT N'GY', N'GUY', 328, N'GY', N'Guyana', N'Georgetown', N'214970', 770000, N'SA', N'.gy', N'GYD', N'Dollar', N'592', N'', N'', N'en-GY', 3378535, N'SR,BR,VE', N'' UNION ALL
SELECT N'HK', N'HKG', 344, N'HK', N'Hong Kong', N'Hong Kong', N'1092', 6898686, N'AS', N'.hk', N'HKD', N'Dollar', N'852', N'', N'', N'zh-HK,yue,zh,en', 1819730, N'', N'' UNION ALL
SELECT N'HM', N'HMD', 334, N'HM', N'Heard Island and McDonald Islands', N'', N'412', 0, N'AN', N'.hm', N'AUD', N'Dollar', N' ', N'', N'', N'', 1547314, N'', N'' UNION ALL
SELECT N'HN', N'HND', 340, N'HO', N'Honduras', N'Tegucigalpa', N'112090', 7639000, N'NA', N'.hn', N'HNL', N'Lempira', N'504', N'@@####', N'^([A-Z]{2}\d{4})$', N'es-HN', 3608932, N'GT,NI,SV', N'' UNION ALL
SELECT N'HR', N'HRV', 191, N'HR', N'Croatia', N'Zagreb', N'56542', 4491000, N'EU', N'.hr', N'HRK', N'Kuna', N'385', N'HR-#####', N'^(?:HR)*(\d{5})$', N'hr-HR,sr', 3202326, N'HU,SI,CS,BA,ME,RS', N'' UNION ALL
SELECT N'HT', N'HTI', 332, N'HA', N'Haiti', N'Port-au-Prince', N'27750', 8924000, N'NA', N'.ht', N'HTG', N'Gourde', N'509', N'HT####', N'^(?:HT)*(\d{4})$', N'ht,fr-HT', 3723988, N'DO', N'' UNION ALL
SELECT N'HU', N'HUN', 348, N'HU', N'Hungary', N'Budapest', N'93030', 9930000, N'EU', N'.hu', N'HUF', N'Forint', N'36', N'####', N'^(\d{4})$', N'hu-HU', 719819, N'SK,SI,RO,UA,CS,HR,AT,RS', N''
COMMIT;
RAISERROR (N'[dbo].[geonames]: Insert Batch: 2.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[geonames]([ISO], [ISO3], [ISO-Numeric], [fips], [Country], [Capital], [Area(in sq km)], [Population], [Continent], [tld], [CurrencyCode], [CurrencyName], [Phone], [Postal Code Format], [Postal Code Regex], [Languages], [geonameid], [neighbours], [EquivalentFipsCode])
SELECT N'ID', N'IDN', 360, N'ID', N'Indonesia', N'Jakarta', N'1919440', 237512000, N'AS', N'.id', N'IDR', N'Rupiah', N'62', N'#####', N'^(\d{5})$', N'id,en,nl,jv', 1643084, N'PG,TL,MY', N'' UNION ALL
SELECT N'IE', N'IRL', 372, N'EI', N'Ireland', N'Dublin', N'70280', 4156000, N'EU', N'.ie', N'EUR', N'Euro', N'353', N'', N'', N'en-IE,ga-IE', 2963597, N'GB', N'' UNION ALL
SELECT N'IL', N'ISR', 376, N'IS', N'Israel', N'Jerusalem', N'20770', 6500000, N'AS', N'.il', N'ILS', N'Shekel', N'972', N'#####', N'^(\d{5})$', N'he,ar-IL,en-IL,', 294640, N'SY,JO,LB,EG,PS', N'' UNION ALL
SELECT N'IM', N'IMN', 833, N'IM', N'Isle of Man', N'Douglas, Isle of Man', N'572', 75049, N'EU', N'.im', N'GBP', N'Pound', N'-1580', N'@# #@@|@## #@@|@@# #@@|@@## #@@|@#@ #@@|@@#@ #@@|GIR0AA', N'^(([A-Z]\d{2}[A-Z]{2})|([A-Z]\d{3}[A-Z]{2})|([A-Z]{2}\d{2}[A-Z]{2})|([A-Z]{2}\d{3}[A-Z]{2})|([A-Z]\d[A-Z]\d[A-Z]{2})|([A-Z]{2}\d[A-Z]\d[A-Z]{2})|(GIR0AA))$', N'en,gv', 3042225, N'', N'' UNION ALL
SELECT N'IN', N'IND', 356, N'IN', N'India', N'New Delhi', N'3287590', 1147995000, N'AS', N'.in', N'INR', N'Rupee', N'91', N'######', N'^(\d{6})$', N'en-IN,hi,bn,te,mr,ta,ur,gu,ml,kn,or,pa,as,ks,sd,sa,ur-IN', 1269750, N'CN,NP,MM,BT,PK,BD', N'' UNION ALL
SELECT N'IO', N'IOT', 86, N'IO', N'British Indian Ocean Territory', N'Diego Garcia', N'60', 0, N'AS', N'.io', N'USD', N'Dollar', N'246', N'', N'', N'en-IO', 1282588, N'', N'' UNION ALL
SELECT N'IQ', N'IRQ', 368, N'IZ', N'Iraq', N'Baghdad', N'437072', 28221000, N'AS', N'.iq', N'IQD', N'Dinar', N'964', N'#####', N'^(\d{5})$', N'ar-IQ,ku,hy', 99237, N'SY,SA,IR,JO,TR,KW', N'' UNION ALL
SELECT N'IR', N'IRN', 364, N'IR', N'Iran', N'Tehran', N'1648000', 65875000, N'AS', N'.ir', N'IRR', N'Rial', N'98', N'##########', N'^(\d{10})$', N'fa-IR,ku', 130758, N'TM,AF,IQ,AM,PK,AZ,TR', N'' UNION ALL
SELECT N'IS', N'ISL', 352, N'IC', N'Iceland', N'Reykjavík', N'103000', 304000, N'EU', N'.is', N'ISK', N'Krona', N'354', N'###', N'^(\d{3})$', N'is,en,de,da,sv,no', 2629691, N'', N'' UNION ALL
SELECT N'IT', N'ITA', 380, N'IT', N'Italy', N'Rome', N'301230', 58145000, N'EU', N'.it', N'EUR', N'Euro', N'39', N'####', N'^(\d{5})$', N'it-IT,de-IT,fr-IT,sl', 3175395, N'CH,VA,SI,SM,FR,AT', N'' UNION ALL
SELECT N'JE', N'JEY', 832, N'JE', N'Jersey', N'Saint Helier', N'116', 90812, N'EU', N'.je', N'GBP', N'Pound', N'-1490', N'@# #@@|@## #@@|@@# #@@|@@## #@@|@#@ #@@|@@#@ #@@|GIR0AA', N'^(([A-Z]\d{2}[A-Z]{2})|([A-Z]\d{3}[A-Z]{2})|([A-Z]{2}\d{2}[A-Z]{2})|([A-Z]{2}\d{3}[A-Z]{2})|([A-Z]\d[A-Z]\d[A-Z]{2})|([A-Z]{2}\d[A-Z]\d[A-Z]{2})|(GIR0AA))$', N'en,pt', 3042142, N'', N'' UNION ALL
SELECT N'JM', N'JAM', 388, N'JM', N'Jamaica', N'Kingston', N'10991', 2801000, N'NA', N'.jm', N'JMD', N'Dollar', N'-875', N'', N'', N'en-JM', 3489940, N'', N'' UNION ALL
SELECT N'JO', N'JOR', 400, N'JO', N'Jordan', N'Amman', N'92300', 6198000, N'AS', N'.jo', N'JOD', N'Dinar', N'962', N'#####', N'^(\d{5})$', N'ar-JO,en', 248816, N'SY,SA,IQ,IL,PS', N'' UNION ALL
SELECT N'JP', N'JPN', 392, N'JA', N'Japan', N'Tokyo', N'377835', 127288000, N'AS', N'.jp', N'JPY', N'Yen', N'81', N'###-####', N'^(\d{7})$', N'ja', 1861060, N'', N'' UNION ALL
SELECT N'KE', N'KEN', 404, N'KE', N'Kenya', N'Nairobi', N'582650', 37953000, N'AF', N'.ke', N'KES', N'Shilling', N'254', N'#####', N'^(\d{5})$', N'en-KE,sw-KE', 192950, N'ET,TZ,SD,SO,UG', N'' UNION ALL
SELECT N'KG', N'KGZ', 417, N'KG', N'Kyrgyzstan', N'Bishkek', N'198500', 5356000, N'AS', N'.kg', N'KGS', N'Som', N'996', N'######', N'^(\d{6})$', N'ky,uz,ru', 1527747, N'CN,TJ,UZ,KZ', N'' UNION ALL
SELECT N'KH', N'KHM', 116, N'CB', N'Cambodia', N'Phnom Penh', N'181040', 14241000, N'AS', N'.kh', N'KHR', N'Riels', N'855', N'#####', N'^(\d{5})$', N'km,fr,en', 1831722, N'LA,TH,VN', N'' UNION ALL
SELECT N'KI', N'KIR', 296, N'KR', N'Kiribati', N'South Tarawa', N'811', 110000, N'OC', N'.ki', N'AUD', N'Dollar', N'686', N'', N'', N'en-KI,gil', 4030945, N'', N'' UNION ALL
SELECT N'KM', N'COM', 174, N'CN', N'Comoros', N'Moroni', N'2170', 731000, N'AF', N'.km', N'KMF', N'Franc', N'269', N'', N'', N'ar,fr-KM', 921929, N'', N'' UNION ALL
SELECT N'KN', N'KNA', 659, N'SC', N'Saint Kitts and Nevis', N'Basseterre', N'261', 39000, N'NA', N'.kn', N'XCD', N'Dollar', N'-868', N'', N'', N'en-KN', 3575174, N'', N'' UNION ALL
SELECT N'KP', N'PRK', 408, N'KN', N'North Korea', N'Pyongyang', N'120540', 22912177, N'AS', N'.kp', N'KPW', N'Won', N'850', N'###-###', N'^(\d{6})$', N'ko-KP', 1873107, N'CN,KR,RU', N'' UNION ALL
SELECT N'KR', N'KOR', 410, N'KS', N'South Korea', N'Seoul', N'98480', 48422644, N'AS', N'.kr', N'KRW', N'Won', N'82', N'SEOUL ###-###', N'^(?:SEOUL)*(\d{6})$', N'ko-KR,en', 1835841, N'KP', N'' UNION ALL
SELECT N'KW', N'KWT', 414, N'KU', N'Kuwait', N'Kuwait City', N'17820', 2596000, N'AS', N'.kw', N'KWD', N'Dinar', N'965', N'#####', N'^(\d{5})$', N'ar-KW,en', 285570, N'SA,IQ', N'' UNION ALL
SELECT N'KY', N'CYM', 136, N'CJ', N'Cayman Islands', N'George Town', N'262', 44270, N'NA', N'.ky', N'KYD', N'Dollar', N'-344', N'', N'', N'en-KY', 3580718, N'', N'' UNION ALL
SELECT N'KZ', N'KAZ', 398, N'KZ', N'Kazakhstan', N'Astana', N'2717300', 15340000, N'AS', N'.kz', N'KZT', N'Tenge', N'7', N'######', N'^(\d{6})$', N'kk,ru', 1522867, N'TM,CN,KG,UZ,RU', N'' UNION ALL
SELECT N'LA', N'LAO', 418, N'LA', N'Laos', N'Vientiane', N'236800', 6677000, N'AS', N'.la', N'LAK', N'Kip', N'856', N'#####', N'^(\d{5})$', N'lo,fr,en', 1655842, N'CN,MM,KH,TH,VN', N'' UNION ALL
SELECT N'LB', N'LBN', 422, N'LE', N'Lebanon', N'Beirut', N'10400', 3971000, N'AS', N'.lb', N'LBP', N'Pound', N'961', N'#### ####|####', N'^(\d{4}(\d{4})?)$', N'ar-LB,fr-LB,en,hy', 272103, N'SY,IL', N'' UNION ALL
SELECT N'LC', N'LCA', 662, N'ST', N'Saint Lucia', N'Castries', N'616', 172000, N'NA', N'.lc', N'XCD', N'Dollar', N'-757', N'', N'', N'en-LC', 3576468, N'', N'' UNION ALL
SELECT N'LI', N'LIE', 438, N'LS', N'Liechtenstein', N'Vaduz', N'160', 34000, N'EU', N'.li', N'CHF', N'Franc', N'423', N'####', N'^(\d{4})$', N'de-LI', 3042058, N'CH,AT', N'' UNION ALL
SELECT N'LK', N'LKA', 144, N'CE', N'Sri Lanka', N'Colombo', N'65610', 21128000, N'AS', N'.lk', N'LKR', N'Rupee', N'94', N'#####', N'^(\d{5})$', N'si,ta,en', 1227603, N'', N'' UNION ALL
SELECT N'LR', N'LBR', 430, N'LI', N'Liberia', N'Monrovia', N'111370', 3334000, N'AF', N'.lr', N'LRD', N'Dollar', N'231', N'####', N'^(\d{4})$', N'en-LR', 2275384, N'SL,CI,GN', N'' UNION ALL
SELECT N'LS', N'LSO', 426, N'LT', N'Lesotho', N'Maseru', N'30355', 2128000, N'AF', N'.ls', N'LSL', N'Loti', N'266', N'###', N'^(\d{3})$', N'en-LS,st,zu,xh', 932692, N'ZA', N'' UNION ALL
SELECT N'LT', N'LTU', 440, N'LH', N'Lithuania', N'Vilnius', N'65200', 3565000, N'EU', N'.lt', N'LTL', N'Litas', N'370', N'LT-#####', N'^(?:LT)*(\d{5})$', N'lt,ru,pl', 597427, N'PL,BY,RU,LV', N'' UNION ALL
SELECT N'LU', N'LUX', 442, N'LU', N'Luxembourg', N'Luxembourg', N'2586', 486000, N'EU', N'.lu', N'EUR', N'Euro', N'352', N'####', N'^(\d{4})$', N'lb,de-LU,fr-LU', 2960313, N'DE,BE,FR', N'' UNION ALL
SELECT N'LV', N'LVA', 428, N'LG', N'Latvia', N'Riga', N'64589', 2245000, N'EU', N'.lv', N'LVL', N'Lat', N'371', N'LV-####', N'^(?:LV)*(\d{4})$', N'lv,ru,lt', 458258, N'LT,EE,BY,RU', N'' UNION ALL
SELECT N'LY', N'LBY', 434, N'LY', N'Libya', N'Tripolis', N'1759540', 6173000, N'AF', N'.ly', N'LYD', N'Dinar', N'218', N'', N'', N'ar-LY,it,en', 2215636, N'TD,NE,DZ,SD,TN,EG', N'' UNION ALL
SELECT N'MA', N'MAR', 504, N'MO', N'Morocco', N'Rabat', N'446550', 34272000, N'AF', N'.ma', N'MAD', N'Dirham', N'212', N'#####', N'^(\d{5})$', N'ar-MA,fr', 2542007, N'DZ,EH,ES', N'' UNION ALL
SELECT N'MC', N'MCO', 492, N'MN', N'Monaco', N'Monaco', N'1.95', 32000, N'EU', N'.mc', N'EUR', N'Euro', N'377', N'#####', N'^(\d{5})$', N'fr-MC,en,it', 2993457, N'FR', N'' UNION ALL
SELECT N'MD', N'MDA', 498, N'MD', N'Moldova', N'Chis,ina(u', N'33843', 4324000, N'EU', N'.md', N'MDL', N'Leu', N'373', N'MD-####', N'^(?:MD)*(\d{4})$', N'ro,ru,gag,tr', 617790, N'RO,UA', N'' UNION ALL
SELECT N'ME', N'MNE', 499, N'MJ', N'Montenegro', N'Podgorica', N'14026', 678000, N'EU', N'.cs', N'EUR', N'Euro', N'381', N'#####', N'^(\d{5})$', N'sr,hu,bs,sq,hr,rom', 3194884, N'AL,HR,BA,RS', N'' UNION ALL
SELECT N'MF', N'MAF', 663, N'RN', N'Saint Martin', N'Marigot', N'53', 33100, N'NA', N'.gp', N'EUR', N'Euro', N'590', N'### ###', N'', N'fr', 3578421, N'', N'' UNION ALL
SELECT N'MG', N'MDG', 450, N'MA', N'Madagascar', N'Antananarivo', N'587040', 20042000, N'AF', N'.mg', N'MGA', N'Ariary', N'261', N'###', N'^(\d{3})$', N'fr-MG,mg', 1062947, N'', N'' UNION ALL
SELECT N'MH', N'MHL', 584, N'RM', N'Marshall Islands', N'Uliga', N'181.3', 11628, N'OC', N'.mh', N'USD', N'Dollar', N'692', N'', N'', N'mh,en-MH', 2080185, N'', N'' UNION ALL
SELECT N'MK', N'MKD', 807, N'MK', N'Macedonia', N'Skopje', N'25333', 2061000, N'EU', N'.mk', N'MKD', N'Denar', N'389', N'####', N'^(\d{4})$', N'mk,sq,tr,rmm,sr', 718075, N'AL,GR,CS,BG,RS', N'' UNION ALL
SELECT N'ML', N'MLI', 466, N'ML', N'Mali', N'Bamako', N'1240000', 12324000, N'AF', N'.ml', N'XOF', N'Franc', N'223', N'', N'', N'fr-ML,bm', 2453866, N'SN,NE,DZ,CI,GN,MR,BF', N'' UNION ALL
SELECT N'MM', N'MMR', 104, N'BM', N'Myanmar', N'Yangon', N'678500', 47758000, N'AS', N'.mm', N'MMK', N'Kyat', N'95', N'#####', N'^(\d{5})$', N'my', 1327865, N'CN,LA,TH,BD,IN', N'' UNION ALL
SELECT N'MN', N'MNG', 496, N'MG', N'Mongolia', N'Ulan Bator', N'1565000', 2996000, N'AS', N'.mn', N'MNT', N'Tugrik', N'976', N'######', N'^(\d{6})$', N'mn,ru', 2029969, N'CN,RU', N'' UNION ALL
SELECT N'MO', N'MAC', 446, N'MC', N'Macao', N'Macao', N'254', 449198, N'AS', N'.mo', N'MOP', N'Pataca', N'853', N'', N'', N'zh,zh-MO', 1821275, N'', N'' UNION ALL
SELECT N'MP', N'MNP', 580, N'CQ', N'Northern Mariana Islands', N'Saipan', N'477', 80362, N'OC', N'.mp', N'USD', N'Dollar', N'-669', N'', N'', N'fil,tl,zh,ch-MP,en-MP', 4041467, N'', N'' UNION ALL
SELECT N'MQ', N'MTQ', 474, N'MB', N'Martinique', N'Fort-de-France', N'1100', 432900, N'NA', N'.mq', N'EUR', N'Euro', N'596', N'#####', N'^(\d{5})$', N'fr-MQ', 3570311, N'', N''
COMMIT;
RAISERROR (N'[dbo].[geonames]: Insert Batch: 3.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[geonames]([ISO], [ISO3], [ISO-Numeric], [fips], [Country], [Capital], [Area(in sq km)], [Population], [Continent], [tld], [CurrencyCode], [CurrencyName], [Phone], [Postal Code Format], [Postal Code Regex], [Languages], [geonameid], [neighbours], [EquivalentFipsCode])
SELECT N'MR', N'MRT', 478, N'MR', N'Mauritania', N'Nouakchott', N'1030700', 3364000, N'AF', N'.mr', N'MRO', N'Ouguiya', N'222', N'', N'', N'ar-MR,fuc,snk,fr,mey,wo', 2378080, N'SN,DZ,EH,ML', N'' UNION ALL
SELECT N'MS', N'MSR', 500, N'MH', N'Montserrat', N'Plymouth', N'102', 9341, N'NA', N'.ms', N'XCD', N'Dollar', N'-663', N'', N'', N'en-MS', 3578097, N'', N'' UNION ALL
SELECT N'MT', N'MLT', 470, N'MT', N'Malta', N'Valletta', N'316', 403000, N'EU', N'.mt', N'EUR', N'Euro', N'356', N'@@@ ###|@@@ ##', N'^([A-Z]{3}\d{2}\d?)$', N'mt,en-MT', 2562770, N'', N'' UNION ALL
SELECT N'MU', N'MUS', 480, N'MP', N'Mauritius', N'Port Louis', N'2040', 1260000, N'AF', N'.mu', N'MUR', N'Rupee', N'230', N'', N'', N'en-MU,bho,fr', 934292, N'', N'' UNION ALL
SELECT N'MV', N'MDV', 462, N'MV', N'Maldives', N'Malé', N'300', 379000, N'AS', N'.mv', N'MVR', N'Rufiyaa', N'960', N'#####', N'^(\d{5})$', N'dv,en', 1282028, N'', N'' UNION ALL
SELECT N'MW', N'MWI', 454, N'MI', N'Malawi', N'Lilongwe', N'118480', 13931000, N'AF', N'.mw', N'MWK', N'Kwacha', N'265', N'', N'', N'ny,yao,tum,swk', 927384, N'TZ,MZ,ZM', N'' UNION ALL
SELECT N'MX', N'MEX', 484, N'MX', N'Mexico', N'Mexico City', N'1972550', 109955000, N'NA', N'.mx', N'MXN', N'Peso', N'52', N'#####', N'^(\d{5})$', N'es-MX', 3996063, N'GT,US,BZ', N'' UNION ALL
SELECT N'MY', N'MYS', 458, N'MY', N'Malaysia', N'Kuala Lumpur', N'329750', 25259000, N'AS', N'.my', N'MYR', N'Ringgit', N'60', N'#####', N'^(\d{5})$', N'ms-MY,en,zh,ta,te,ml,pa,th', 1733045, N'BN,TH,ID', N'' UNION ALL
SELECT N'MZ', N'MOZ', 508, N'MZ', N'Mozambique', N'Maputo', N'801590', 21284000, N'AF', N'.mz', N'MZN', N'Meticail', N'258', N'####', N'^(\d{4})$', N'pt-MZ,vmw', 1036973, N'ZW,TZ,SZ,ZA,ZM,MW', N'' UNION ALL
SELECT N'NA', N'NAM', 516, N'WA', N'Namibia', N'Windhoek', N'825418', 2063000, N'AF', N'.na', N'NAD', N'Dollar', N'264', N'', N'', N'en-NA,af,de,hz,naq', 3355338, N'ZA,BW,ZM,AO', N'' UNION ALL
SELECT N'NC', N'NCL', 540, N'NC', N'New Caledonia', N'Nouméa', N'19060', 216494, N'OC', N'.nc', N'XPF', N'Franc', N'687', N'#####', N'^(\d{5})$', N'fr-NC', 2139685, N'', N'' UNION ALL
SELECT N'NE', N'NER', 562, N'NG', N'Niger', N'Niamey', N'1267000', 13272000, N'AF', N'.ne', N'XOF', N'Franc', N'227', N'####', N'^(\d{4})$', N'fr-NE,ha,kr,dje', 2440476, N'TD,BJ,DZ,LY,BF,NG,ML', N'' UNION ALL
SELECT N'NF', N'NFK', 574, N'NF', N'Norfolk Island', N'Kingston', N'34.6', 1828, N'OC', N'.nf', N'AUD', N'Dollar', N'672', N'', N'', N'en-NF', 2155115, N'', N'' UNION ALL
SELECT N'NG', N'NGA', 566, N'NI', N'Nigeria', N'Abuja', N'923768', 138283000, N'AF', N'.ng', N'NGN', N'Naira', N'234', N'######', N'^(\d{6})$', N'en-NG,ha,yo,ig,ff', 2328926, N'TD,NE,BJ,CM', N'' UNION ALL
SELECT N'NI', N'NIC', 558, N'NU', N'Nicaragua', N'Managua', N'129494', 5780000, N'NA', N'.ni', N'NIO', N'Cordoba', N'505', N'###-###-#', N'^(\d{7})$', N'es-NI,en', 3617476, N'CR,HN', N'' UNION ALL
SELECT N'NL', N'NLD', 528, N'NL', N'Netherlands', N'Amsterdam', N'41526', 16645000, N'EU', N'.nl', N'EUR', N'Euro', N'31', N'#### @@', N'^(\d{4}[A-Z]{2})$', N'nl-NL,fy-NL', 2750405, N'DE,BE', N'' UNION ALL
SELECT N'NO', N'NOR', 578, N'NO', N'Norway', N'Oslo', N'324220', 4644000, N'EU', N'.no', N'NOK', N'Krone', N'47', N'####', N'^(\d{4})$', N'no,nb,nn', 3144096, N'FI,RU,SE', N'' UNION ALL
SELECT N'NP', N'NPL', 524, N'NP', N'Nepal', N'Kathmandu', N'140800', 29519000, N'AS', N'.np', N'NPR', N'Rupee', N'977', N'#####', N'^(\d{5})$', N'ne,en', 1282988, N'CN,IN', N'' UNION ALL
SELECT N'NR', N'NRU', 520, N'NR', N'Nauru', N'Yaren', N'21', 13000, N'OC', N'.nr', N'AUD', N'Dollar', N'674', N'', N'', N'na,en-NR', 2110425, N'', N'' UNION ALL
SELECT N'NU', N'NIU', 570, N'NE', N'Niue', N'Alofi', N'260', 2166, N'OC', N'.nu', N'NZD', N'Dollar', N'683', N'', N'', N'niu,en-NU', 4036232, N'', N'' UNION ALL
SELECT N'NZ', N'NZL', 554, N'NZ', N'New Zealand', N'Wellington', N'268680', 4154000, N'OC', N'.nz', N'NZD', N'Dollar', N'64', N'####', N'^(\d{4})$', N'en-NZ,mi', 2186224, N'', N'' UNION ALL
SELECT N'OM', N'OMN', 512, N'MU', N'Oman', N'Muscat', N'212460', 3309000, N'AS', N'.om', N'OMR', N'Rial', N'968', N'###', N'^(\d{3})$', N'ar-OM,en,bal,ur', 286963, N'SA,YE,AE', N'' UNION ALL
SELECT N'PA', N'PAN', 591, N'PM', N'Panama', N'Panama City', N'78200', 3292000, N'NA', N'.pa', N'PAB', N'Balboa', N'507', N'', N'', N'es-PA,en', 3703430, N'CR,CO', N'' UNION ALL
SELECT N'PE', N'PER', 604, N'PE', N'Peru', N'Lima', N'1285220', 29041000, N'SA', N'.pe', N'PEN', N'Sol', N'51', N'', N'', N'es-PE,qu,ay', 3932488, N'EC,CL,BO,BR,CO', N'' UNION ALL
SELECT N'PF', N'PYF', 258, N'FP', N'French Polynesia', N'Papeete', N'4167', 270485, N'OC', N'.pf', N'XPF', N'Franc', N'689', N'#####', N'^((97)|(98)7\d{2})$', N'fr-PF,ty', 4020092, N'', N'' UNION ALL
SELECT N'PG', N'PNG', 598, N'PP', N'Papua New Guinea', N'Port Moresby', N'462840', 5921000, N'OC', N'.pg', N'PGK', N'Kina', N'675', N'###', N'^(\d{3})$', N'en-PG,ho,meu,tpi', 2088628, N'ID', N'' UNION ALL
SELECT N'PH', N'PHL', 608, N'RP', N'Philippines', N'Manila', N'300000', 92681000, N'AS', N'.ph', N'PHP', N'Peso', N'63', N'####', N'^(\d{4})$', N'tl,en-PH,fil', 1694008, N'', N'' UNION ALL
SELECT N'PK', N'PAK', 586, N'PK', N'Pakistan', N'Islamabad', N'803940', 167762000, N'AS', N'.pk', N'PKR', N'Rupee', N'92', N'#####', N'^(\d{5})$', N'ur-PK,en-PK,pa,sd,ps,brh', 1168579, N'CN,AF,IR,IN', N'' UNION ALL
SELECT N'PL', N'POL', 616, N'PL', N'Poland', N'Warsaw', N'312685', 38500000, N'EU', N'.pl', N'PLN', N'Zloty', N'48', N'##-###', N'^(\d{5})$', N'pl', 798544, N'DE,LT,SK,CZ,BY,UA,RU', N'' UNION ALL
SELECT N'PM', N'SPM', 666, N'SB', N'Saint Pierre and Miquelon', N'Saint-Pierre', N'242', 7012, N'NA', N'.pm', N'EUR', N'Euro', N'508', N'', N'', N'fr-PM', 3424932, N'', N'' UNION ALL
SELECT N'PN', N'PCN', 612, N'PC', N'Pitcairn', N'Adamstown', N'47', 46, N'OC', N'.pn', N'NZD', N'Dollar', N'', N'', N'', N'en-PN', 4030699, N'', N'' UNION ALL
SELECT N'PR', N'PRI', 630, N'RQ', N'Puerto Rico', N'San Juan', N'9104', 3916632, N'NA', N'.pr', N'USD', N'Dollar', N'+1-787 and 1-939', N'#####-####', N'^(\d{9})$', N'en-PR,es-PR', 4566966, N'', N'' UNION ALL
SELECT N'PS', N'PSE', 275, N'WE', N'Palestinian Territory', N'East Jerusalem', N'5970', 3800000, N'AS', N'.ps', N'ILS', N'Shekel', N'970', N'', N'', N'ar-PS', 6254930, N'JO,IL', N'' UNION ALL
SELECT N'PT', N'PRT', 620, N'PO', N'Portugal', N'Lisbon', N'92391', 10676000, N'EU', N'.pt', N'EUR', N'Euro', N'351', N'####-###', N'^(\d{7})$', N'pt-PT,mwl', 2264397, N'ES', N'' UNION ALL
SELECT N'PW', N'PLW', 585, N'PS', N'Palau', N'Koror', N'458', 20303, N'OC', N'.pw', N'USD', N'Dollar', N'680', N'96940', N'^(96940)$', N'pau,sov,en-PW,tox,ja,fil,zh', 1559582, N'', N'' UNION ALL
SELECT N'PY', N'PRY', 600, N'PA', N'Paraguay', N'Asunción', N'406750', 6831000, N'SA', N'.py', N'PYG', N'Guarani', N'595', N'####', N'^(\d{4})$', N'es-PY,gn', 3437598, N'BO,BR,AR', N'' UNION ALL
SELECT N'QA', N'QAT', 634, N'QA', N'Qatar', N'Doha', N'11437', 928000, N'AS', N'.qa', N'QAR', N'Rial', N'974', N'', N'', N'ar-QA,es', 289688, N'SA', N'' UNION ALL
SELECT N'RE', N'REU', 638, N'RE', N'Reunion', N'Saint-Denis', N'2517', 776948, N'AF', N'.re', N'EUR', N'Euro', N'262', N'#####', N'^((97)|(98)(4|7|8)\d{2})$', N'fr-RE', 935317, N'', N'' UNION ALL
SELECT N'RO', N'ROU', 642, N'RO', N'Romania', N'Bucharest', N'237500', 22246000, N'EU', N'.ro', N'RON', N'Leu', N'40', N'######', N'^(\d{6})$', N'ro,hu,rom', 798549, N'MD,HU,UA,CS,BG,RS', N'' UNION ALL
SELECT N'RS', N'SRB', 688, N'RB', N'Serbia', N'Belgrade', N'88361', 10159000, N'EU', N'.rs', N'RSD', N'Dinar', N'381', N'######', N'^(\d{6})$', N'sr,hu,bs,rom', 6290252, N'AL,HU,MK,RO,HR,BA,BG,ME', N'' UNION ALL
SELECT N'RU', N'RUS', 643, N'RS', N'Russia', N'Moscow', N'1.71E+07', 140702000, N'EU', N'.ru', N'RUB', N'Ruble', N'7', N'######', N'^(\d{6})$', N'ru-RU', 2017370, N'GE,CN,BY,UA,KZ,LV,PL,EE,LT,FI,MN,NO,AZ,KP', N'' UNION ALL
SELECT N'RW', N'RWA', 646, N'RW', N'Rwanda', N'Kigali', N'26338', 10186000, N'AF', N'.rw', N'RWF', N'Franc', N'250', N'', N'', N'rw,en-RW,fr-RW,sw', 49518, N'TZ,CD,BI,UG', N'' UNION ALL
SELECT N'SA', N'SAU', 682, N'SA', N'Saudi Arabia', N'Riyadh', N'1960582', 28161000, N'AS', N'.sa', N'SAR', N'Rial', N'966', N'#####', N'^(\d{5})$', N'ar-SA', 102358, N'QA,OM,IQ,YE,JO,AE,KW', N'' UNION ALL
SELECT N'SB', N'SLB', 90, N'BP', N'Solomon Islands', N'Honiara', N'28450', 581000, N'OC', N'.sb', N'SBD', N'Dollar', N'677', N'', N'', N'en-SB,tpi', 2103350, N'', N'' UNION ALL
SELECT N'SC', N'SYC', 690, N'SE', N'Seychelles', N'Victoria', N'455', 82000, N'AF', N'.sc', N'SCR', N'Rupee', N'248', N'', N'', N'en-SC,fr-SC', 241170, N'', N'' UNION ALL
SELECT N'SD', N'SDN', 736, N'SU', N'Sudan', N'Khartoum', N'2505810', 40218000, N'AF', N'.sd', N'SDG', N'Dinar', N'249', N'#####', N'^(\d{5})$', N'ar-SD,en,fia', 366755, N'TD,ER,ET,LY,KE,CF,CD,UG,EG', N'' UNION ALL
SELECT N'SE', N'SWE', 752, N'SW', N'Sweden', N'Stockholm', N'449964', 9045000, N'EU', N'.se', N'SEK', N'Krona', N'46', N'SE-### ##', N'^(?:SE)*(\d{5})$', N'sv-SE,se,sma,fi-SE', 2661886, N'NO,FI', N'' UNION ALL
SELECT N'SG', N'SGP', 702, N'SN', N'Singapore', N'Singapur', N'692.7', 4608000, N'AS', N'.sg', N'SGD', N'Dollar', N'65', N'######', N'^(\d{6})$', N'cmn,en-SG,ms-SG,ta-SG,zh-SG', 1880251, N'', N'' UNION ALL
SELECT N'SH', N'SHN', 654, N'SH', N'Saint Helena', N'Jamestown', N'410', 7460, N'AF', N'.sh', N'SHP', N'Pound', N'290', N'STHL 1ZZ', N'^(STHL1ZZ)$', N'en-SH', 3370751, N'', N'' UNION ALL
SELECT N'SI', N'SVN', 705, N'SI', N'Slovenia', N'Ljubljana', N'20273', 2007000, N'EU', N'.si', N'EUR', N'Euro', N'386', N'SI- ####', N'^(?:SI)*(\d{4})$', N'sl,sh', 3190538, N'HU,IT,HR,AT', N''
COMMIT;
RAISERROR (N'[dbo].[geonames]: Insert Batch: 4.....Done!', 10, 1) WITH NOWAIT;
GO

BEGIN TRANSACTION;
INSERT INTO [dbo].[geonames]([ISO], [ISO3], [ISO-Numeric], [fips], [Country], [Capital], [Area(in sq km)], [Population], [Continent], [tld], [CurrencyCode], [CurrencyName], [Phone], [Postal Code Format], [Postal Code Regex], [Languages], [geonameid], [neighbours], [EquivalentFipsCode])
SELECT N'SJ', N'SJM', 744, N'SV', N'Svalbard and Jan Mayen', N'Longyearbyen', N'62049', 2265, N'EU', N'.sj', N'NOK', N'Krone', N'47', N'', N'', N'no,ru', 607072, N'', N'' UNION ALL
SELECT N'SK', N'SVK', 703, N'LO', N'Slovakia', N'Bratislava', N'48845', 5455000, N'EU', N'.sk', N'EUR', N'Euro', N'421', N'### ##', N'^(\d{5})$', N'sk,hu', 3057568, N'PL,HU,CZ,UA,AT', N'' UNION ALL
SELECT N'SL', N'SLE', 694, N'SL', N'Sierra Leone', N'Freetown', N'71740', 6286000, N'AF', N'.sl', N'SLL', N'Leone', N'232', N'', N'', N'en-SL,men,tem', 2403846, N'LR,GN', N'' UNION ALL
SELECT N'SM', N'SMR', 674, N'SM', N'San Marino', N'San Marino', N'61.2', 29000, N'EU', N'.sm', N'EUR', N'Euro', N'378', N'4789#', N'^(4789\d)$', N'it-SM', 3168068, N'IT', N'' UNION ALL
SELECT N'SN', N'SEN', 686, N'SG', N'Senegal', N'Dakar', N'196190', 12853000, N'AF', N'.sn', N'XOF', N'Franc', N'221', N'#####', N'^(\d{5})$', N'fr-SN,wo,fuc,mnk', 2245662, N'GN,MR,GW,GM,ML', N'' UNION ALL
SELECT N'SO', N'SOM', 706, N'SO', N'Somalia', N'Mogadishu', N'637657', 9379000, N'AF', N'.so', N'SOS', N'Shilling', N'252', N'@@ #####', N'^([A-Z]{2}\d{5})$', N'so-SO,ar-SO,it,en-SO', 51537, N'ET,KE,DJ', N'' UNION ALL
SELECT N'SR', N'SUR', 740, N'NS', N'Suriname', N'Paramaribo', N'163270', 475000, N'SA', N'.sr', N'SRD', N'Dollar', N'597', N'', N'', N'nl-SR,en,srn,hns,jv', 3382998, N'GY,BR,GF', N'' UNION ALL
SELECT N'ST', N'STP', 678, N'TP', N'Sao Tome and Principe', N'São Tomé', N'1001', 205000, N'AF', N'.st', N'STD', N'Dobra', N'239', N'', N'', N'pt-ST', 2410758, N'', N'' UNION ALL
SELECT N'SV', N'SLV', 222, N'ES', N'El Salvador', N'San Salvador', N'21040', 7066000, N'NA', N'.sv', N'USD', N'Dollar', N'503', N'CP ####', N'^(?:CP)*(\d{4})$', N'es-SV', 3585968, N'GT,HN', N'' UNION ALL
SELECT N'SY', N'SYR', 760, N'SY', N'Syria', N'Damascus', N'185180', 19747000, N'AS', N'.sy', N'SYP', N'Pound', N'963', N'', N'', N'ar-SY,ku,hy,arc,fr,en', 163843, N'IQ,JO,IL,TR,LB', N'' UNION ALL
SELECT N'SZ', N'SWZ', 748, N'WZ', N'Swaziland', N'Mbabane', N'17363', 1128000, N'AF', N'.sz', N'SZL', N'Lilangeni', N'268', N'@###', N'^([A-Z]\d{3})$', N'en-SZ,ss-SZ', 934841, N'ZA,MZ', N'' UNION ALL
SELECT N'TC', N'TCA', 796, N'TK', N'Turks and Caicos Islands', N'Cockburn Town', N'430', 20556, N'NA', N'.tc', N'USD', N'Dollar', N'-648', N'TKCA 1ZZ', N'^(TKCA 1ZZ)$', N'en-TC', 3576916, N'', N'' UNION ALL
SELECT N'TD', N'TCD', 148, N'CD', N'Chad', N'N''Djamena', N'1284000', 10111000, N'AF', N'.td', N'XAF', N'Franc', N'235', N'', N'', N'fr-TD,ar-TD,sre', 2434508, N'NE,LY,CF,SD,CM,NG', N'' UNION ALL
SELECT N'TF', N'ATF', 260, N'FS', N'French Southern Territories', N'Martin-de-Viviès', N'7829', 0, N'AN', N'.tf', N'EUR', N'Euro ', N'', N'', N'', N'fr', 1546748, N'', N'' UNION ALL
SELECT N'TG', N'TGO', 768, N'TO', N'Togo', N'Lomé', N'56785', 5858000, N'AF', N'.tg', N'XOF', N'Franc', N'228', N'', N'', N'fr-TG,ee,hna,kbp,dag,ha', 2363686, N'BJ,GH,BF', N'' UNION ALL
SELECT N'TH', N'THA', 764, N'TH', N'Thailand', N'Bangkok', N'514000', 65493000, N'AS', N'.th', N'THB', N'Baht', N'66', N'#####', N'^(\d{5})$', N'th,en', 1605651, N'LA,MM,KH,MY', N'' UNION ALL
SELECT N'TJ', N'TJK', 762, N'TI', N'Tajikistan', N'Dushanbe', N'143100', 7211000, N'AS', N'.tj', N'TJS', N'Somoni', N'992', N'######', N'^(\d{6})$', N'tg,ru', 1220409, N'CN,AF,KG,UZ', N'' UNION ALL
SELECT N'TK', N'TKL', 772, N'TL', N'Tokelau', N'', N'10', 1405, N'OC', N'.tk', N'NZD', N'Dollar', N'690', N'', N'', N'tkl,en-TK', 4031074, N'', N'' UNION ALL
SELECT N'TL', N'TLS', 626, N'TT', N'East Timor', N'Dili', N'15007', 1107000, N'OC', N'.tp', N'USD', N'Dollar', N'670', N'', N'', N'tet,pt-TL,id,en', 1966436, N'ID', N'' UNION ALL
SELECT N'TM', N'TKM', 795, N'TX', N'Turkmenistan', N'Ashgabat', N'488100', 5179000, N'AS', N'.tm', N'TMT', N'Manat', N'993', N'######', N'^(\d{6})$', N'tk,ru,uz', 1218197, N'AF,IR,UZ,KZ', N'' UNION ALL
SELECT N'TN', N'TUN', 788, N'TS', N'Tunisia', N'Tunis', N'163610', 10378000, N'AF', N'.tn', N'TND', N'Dinar', N'216', N'####', N'^(\d{4})$', N'ar-TN,fr', 2464461, N'DZ,LY', N'' UNION ALL
SELECT N'TO', N'TON', 776, N'TN', N'Tonga', N'Nuku''alofa', N'748', 118000, N'OC', N'.to', N'TOP', N'Pa''anga', N'676', N'', N'', N'to,en-TO', 4032283, N'', N'' UNION ALL
SELECT N'TR', N'TUR', 792, N'TU', N'Turkey', N'Ankara', N'780580', 71892000, N'AS', N'.tr', N'TRY', N'Lira', N'90', N'#####', N'^(\d{5})$', N'tr-TR,ku,diq,az,av', 298795, N'SY,GE,IQ,IR,GR,AM,AZ,BG', N'' UNION ALL
SELECT N'TT', N'TTO', 780, N'TD', N'Trinidad and Tobago', N'Port of Spain', N'5128', 1047000, N'NA', N'.tt', N'TTD', N'Dollar', N'-867', N'', N'', N'en-TT,hns,fr,es,zh', 3573591, N'', N'' UNION ALL
SELECT N'TV', N'TUV', 798, N'TV', N'Tuvalu', N'Vaiaku', N'26', 12000, N'OC', N'.tv', N'AUD', N'Dollar', N'688', N'', N'', N'tvl,en,sm,gil', 2110297, N'', N'' UNION ALL
SELECT N'TW', N'TWN', 158, N'TW', N'Taiwan', N'Taipei', N'35980', 22894384, N'AS', N'.tw', N'TWD', N'Dollar', N'886', N'#####', N'^(\d{5})$', N'zh-TW,zh,nan,hak', 1668284, N'', N'' UNION ALL
SELECT N'TZ', N'TZA', 834, N'TZ', N'Tanzania', N'Dar es Salaam', N'945087', 40213000, N'AF', N'.tz', N'TZS', N'Shilling', N'255', N'', N'', N'sw-TZ,en,ar', 149590, N'MZ,KE,CD,RW,ZM,BI,UG,MW', N'' UNION ALL
SELECT N'UA', N'UKR', 804, N'UP', N'Ukraine', N'Kiev', N'603700', 45994000, N'EU', N'.ua', N'UAH', N'Hryvnia', N'380', N'#####', N'^(\d{5})$', N'uk,ru-UA,rom,pl,hu', 690791, N'PL,MD,HU,SK,BY,RO,RU', N'' UNION ALL
SELECT N'UG', N'UGA', 800, N'UG', N'Uganda', N'Kampala', N'236040', 31367000, N'AF', N'.ug', N'UGX', N'Shilling', N'256', N'', N'', N'en-UG,lg,sw,ar', 226074, N'TZ,KE,SD,CD,RW', N'' UNION ALL
SELECT N'UM', N'UMI', 581, N'', N'United States Minor Outlying Islands', N'', N'0', 0, N'OC', N'.um', N'USD', N'Dollar ', N'', N'', N'', N'en-UM', 5854968, N'', N'' UNION ALL
SELECT N'US', N'USA', 840, N'US', N'United States', N'Washington', N'9629091', 303824000, N'NA', N'.us', N'USD', N'Dollar', N'1', N'#####-####', N'^(\d{9})$', N'en-US,es-US,haw', 6252001, N'CA,MX,CU', N'' UNION ALL
SELECT N'UY', N'URY', 858, N'UY', N'Uruguay', N'Montevideo', N'176220', 3477000, N'SA', N'.uy', N'UYU', N'Peso', N'598', N'#####', N'^(\d{5})$', N'es-UY', 3439705, N'BR,AR', N'' UNION ALL
SELECT N'UZ', N'UZB', 860, N'UZ', N'Uzbekistan', N'Tashkent', N'447400', 28268000, N'AS', N'.uz', N'UZS', N'Som', N'998', N'######', N'^(\d{6})$', N'uz,ru,tg', 1512440, N'TM,AF,KG,TJ,KZ', N'' UNION ALL
SELECT N'VA', N'VAT', 336, N'VT', N'Vatican', N'Vatican City', N'0.44', 921, N'EU', N'.va', N'EUR', N'Euro', N'379', N'', N'', N'la,it,fr', 3164670, N'IT', N'' UNION ALL
SELECT N'VC', N'VCT', 670, N'VC', N'Saint Vincent and the Grenadines', N'Kingstown', N'389', 117534, N'NA', N'.vc', N'XCD', N'Dollar', N'-783', N'', N'', N'en-VC,fr', 3577815, N'', N'' UNION ALL
SELECT N'VE', N'VEN', 862, N'VE', N'Venezuela', N'Caracas', N'912050', 26414000, N'SA', N'.ve', N'VEF', N'Bolivar', N'58', N'####', N'^(\d{4})$', N'es-VE', 3625428, N'GY,BR,CO', N'' UNION ALL
SELECT N'VG', N'VGB', 92, N'VI', N'British Virgin Islands', N'Road Town', N'153', 21730, N'NA', N'.vg', N'USD', N'Dollar', N'-283', N'', N'', N'en-VG', 3577718, N'', N'' UNION ALL
SELECT N'VI', N'VIR', 850, N'VQ', N'U.S. Virgin Islands', N'Charlotte Amalie', N'352', 108708, N'NA', N'.vi', N'USD', N'Dollar', N'-339', N'', N'', N'en-VI', 4796775, N'', N'' UNION ALL
SELECT N'VN', N'VNM', 704, N'VM', N'Vietnam', N'Hanoi', N'329560', 86116000, N'AS', N'.vn', N'VND', N'Dong', N'84', N'######', N'^(\d{6})$', N'vi,en,fr,zh,km', 1562822, N'CN,LA,KH', N'' UNION ALL
SELECT N'VU', N'VUT', 548, N'NH', N'Vanuatu', N'Port Vila', N'12200', 215000, N'OC', N'.vu', N'VUV', N'Vatu', N'678', N'', N'', N'bi,en-VU,fr-VU', 2134431, N'', N'' UNION ALL
SELECT N'WF', N'WLF', 876, N'WF', N'Wallis and Futuna', N'Matâ''Utu', N'274', 16025, N'OC', N'.wf', N'XPF', N'Franc', N'681', N'', N'', N'wls,fud,fr-WF', 4034749, N'', N'' UNION ALL
SELECT N'WS', N'WSM', 882, N'WS', N'Samoa', N'Apia', N'2944', 217000, N'OC', N'.ws', N'WST', N'Tala', N'685', N'', N'', N'sm,en-WS', 4034894, N'', N'' UNION ALL
SELECT N'YE', N'YEM', 887, N'YM', N'Yemen', N'San‘a’', N'527970', 23013000, N'AS', N'.ye', N'YER', N'Rial', N'967', N'', N'', N'ar-YE', 69543, N'SA,OM', N'' UNION ALL
SELECT N'YT', N'MYT', 175, N'MF', N'Mayotte', N'Mamoudzou', N'374', 159042, N'AF', N'.yt', N'EUR', N'Euro', N'269', N'#####', N'^(\d{5})$', N'fr-YT', 1024031, N'', N'' UNION ALL
SELECT N'ZA', N'ZAF', 710, N'SF', N'South Africa', N'Pretoria', N'1219912', 43786000, N'AF', N'.za', N'ZAR', N'Rand', N'27', N'####', N'^(\d{4})$', N'zu,xh,af,nso,en-ZA,tn,st,ts', 953987, N'ZW,SZ,MZ,BW,NA,LS', N'' UNION ALL
SELECT N'ZM', N'ZMB', 894, N'ZA', N'Zambia', N'Lusaka', N'752614', 11669000, N'AF', N'.zm', N'ZMK', N'Kwacha', N'260', N'#####', N'^(\d{5})$', N'en-ZM,bem,loz,lun,lue,ny,toi', 895949, N'ZW,TZ,MZ,CD,NA,MW,AO', N'' UNION ALL
SELECT N'ZW', N'ZWE', 716, N'ZI', N'Zimbabwe', N'Harare', N'390580', 12382000, N'AF', N'.zw', N'ZWL', N'Dollar', N'263', N'', N'', N'en-ZW,sn,nr,nd', 878675, N'ZA,MZ,BW,ZM', N''
COMMIT;
RAISERROR (N'[dbo].[geonames]: Insert Batch: 5.....Done!', 10, 1) WITH NOWAIT;
GO
```

Don’t forget to index the appropriate columns!

```
CREATE INDEX idx_continent ON dbo.geonames (Continent);
```

Here's the query to create a lists of countries grouped by continent code.

```
SELECT DISTINCT Continent, Counties = LEFT(countries.Continent_Members, LEN(countries.Continent_Members)-1)
FROM dbo.geonames geo1
CROSS APPLY
(
	SELECT Country + ',' AS [text()]
		FROM dbo.geonames geo2
		WHERE geo1.Continent = geo2.Continent
		ORDER BY Country
		FOR XML PATH('')
) countries (Continent_Members);
```

Now we have a list of countries in each continent.

[![Contient country list with CROSS APPLY]({{ site.baseurl }}/assets/2009/07/image_thumb22.png "Contient country list with CROSS APPLY")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image22.png)

Create this same table structure, with data, in [MySQL](http://www.mysql.com) by modifying the [TSQL](http://msdn.microsoft.com/en-us/library/ms189826(SQL.90).aspx) above or any alternative method you prefer. Here’s how much simpler the equivalent query is to create in [MySQL](http://www.mysql.com).

```
SELECT Continent, GROUP_CONCAT(country) AS countries
FROM geonames
GROUP BY Continent;
```

[![Contient country list with GROUP_CONCAT]({{ site.baseurl }}/assets/2009/07/image_thumb23.png "Contient country list with GROUP\_CONCAT")](http://www.youdidwhatwithtsql.com/wp-content/uploads/2009/07/image23.png)

