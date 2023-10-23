SELECT DISTINCT brand FROM sales.products -- verificando quantas marcas de carros distintas existem

-- tabela 1 (maximo)
SELECT
  brand,
  model AS carro_mais_caro,
  price AS preco_mais_caro
FROM
  sales.products AS p
WHERE
  price = (SELECT MAX(price) FROM sales.products WHERE brand = p.brand)
  
-- tabela 2 (minimo)
SELECT
  brand,
  model AS carro_mais_barato,
  price AS preco_mais_barato
FROM
  sales.products AS p
WHERE
  price = (SELECT MIN(price) FROM sales.products WHERE brand = p.brand)
  
-- fazendo um LEFT JOIN das duas tabelas  
SELECT
  t1.brand,
  t1.carro_mais_caro,
  t1.preco_mais_caro,
  t2.carro_mais_barato,
  t2.preco_mais_barato
FROM
  (
    -- tabela 1 (maximo)
    SELECT
      brand,
      model AS carro_mais_caro,
      price AS preco_mais_caro
    FROM
      sales.products AS p
    WHERE
      price = (SELECT MAX(price) FROM sales.products WHERE brand = p.brand)
  ) AS t1
LEFT JOIN
  (
    -- tabela 2 (minimo)
    SELECT
      brand,
      model AS carro_mais_barato,
      price AS preco_mais_barato
    FROM
      sales.products AS p
    WHERE
      price = (SELECT MIN(price) FROM sales.products WHERE brand = p.brand)
  ) AS t2
ON
  t1.brand = t2.brand;