SELECT 
DISTINCT base.CLIENTE,
base.U_AGRUPACION,
base.ARTICULO,
base.CLASIFICACION_3_DES, 
base.DESCRIPCION, 
base4.Suma AS 'Col1',
base3.Suma AS 'Col2',
base2.Suma AS 'Col3',
base1.Suma AS 'Col4',
base.VENDEDOR AS 'Codigo_Vendedor',
base.VENNOM AS 'Vendedor',
NOW() AS Date


FROM base_oic2 AS base
LEFT JOIN(
	SELECT 
		CLIENTE,
		CLASIFICACION_3_DES,
		ARTICULO, DESCRIPCION,
		SUM(CASE WHEN VTAS < 0 THEN -1*CANTIDAD ELSE CANTIDAD END) AS Suma
	FROM base_oic2 
	WHERE 
		MONTH(FECHA) = MONTH(DATE_ADD(NOW(), INTERVAL -0 MONTH)) 
		AND 
		CLIENTE IS NOT NULL
	GROUP BY CLIENTE, CLASIFICACION_3_DES, ARTICULO, DESCRIPCION) AS base1
ON(base.CLIENTE = base1.CLIENTE AND base.ARTICULO = base1.ARTICULO )

LEFT JOIN(
	SELECT 
		CLIENTE,
		CLASIFICACION_3_DES,
		ARTICULO, DESCRIPCION,
		SUM(CASE WHEN VTAS < 0 THEN -1*CANTIDAD ELSE CANTIDAD END) AS Suma
	FROM base_oic2 
	WHERE 
		MONTH(FECHA) = MONTH(DATE_ADD(NOW(), INTERVAL -1 MONTH))  
		AND 
		CLIENTE IS NOT NULL
	GROUP BY CLIENTE, CLASIFICACION_3_DES, ARTICULO, DESCRIPCION) AS base2
ON(base.CLIENTE = base2.CLIENTE AND base.ARTICULO = base2.ARTICULO )

LEFT JOIN(
	SELECT 
		CLIENTE,
		CLASIFICACION_3_DES,
		ARTICULO, DESCRIPCION,
		SUM(CASE WHEN VTAS < 0 THEN -1*CANTIDAD ELSE CANTIDAD END) AS Suma
	FROM base_oic2 
	WHERE 
		MONTH(FECHA) = MONTH(DATE_ADD(NOW(), INTERVAL -2 MONTH))  
		AND 
		CLIENTE IS NOT NULL
	GROUP BY CLIENTE, CLASIFICACION_3_DES, ARTICULO, DESCRIPCION) AS base3
ON(base.CLIENTE = base3.CLIENTE AND base.ARTICULO = base3.ARTICULO )

LEFT JOIN(
	SELECT 
		CLIENTE,
		CLASIFICACION_3_DES,
		ARTICULO, DESCRIPCION,
		SUM(CASE WHEN VTAS < 0 THEN -1*CANTIDAD ELSE CANTIDAD END) AS Suma
	FROM base_oic2 
	WHERE 
		MONTH(FECHA) = MONTH(DATE_ADD(NOW(), INTERVAL -3 MONTH))  
		AND 
		CLIENTE IS NOT NULL
	GROUP BY CLIENTE, CLASIFICACION_3_DES, ARTICULO, DESCRIPCION) AS base4
ON(base.CLIENTE = base4.CLIENTE AND base.ARTICULO = base4.ARTICULO )

WHERE 
	base.CLIENTE IS NOT NULL
	AND
	base.U_AGRUPACION IS NOT NULL 
	AND 
	NOT(base1.Suma IS NULL AND base2.Suma IS NULL AND base3.Suma IS NULL AND base4.Suma IS NULL)
	AND
		(base.CLASIFICACION_5_DES = 'DOBLE BASICO' OR base.CLASIFICACION_5_DES = 'TRIPLE BASICO' OR base.CLASIFICACION_5_DES = 'BASICO')
ORDER BY
	base.U_AGRUPACION,
	base.CLASIFICACION_3_DES, 
	base.DESCRIPCION;