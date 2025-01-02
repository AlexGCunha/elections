SELECT * FROM (
	SELECT ano,
	cpf,
	titulo_eleitoral,
	cargo,
	id_municipio,
	sigla_partido,
	idade,
	instrucao,
	ocupacao,
	estado_civil,
	municipio_nascimento,
	raca
	FROM basedosdados.br_tse_eleicoes.candidatos
	WHERE ano >= 2004) candidatos
LEFT JOIN(
	SELECT ano,
	titulo_eleitoral_candidato,
	id_municipio,
	turno,
	tipo_despesa,
	valor_despesa,
	fonte_recurso
	FROM basedosdados.br_tse_eleicoes.despesas_candidato
	WHERE ano IS NOT NULL AND
	titulo_eleitoral_candidato IS NOT NULL AND
	ano >= 2004) despesas
ON candidatos.ano = despesas.ano AND
candidatos.titulo_eleitoral = despesas.titulo_eleitoral_candidato
LEFT JOIN(
	SELECT ano,
	titulo_eleitoral_candidato,
	SUM(valor_item)AS bens_declarados
	FROM basedosdados.br_tse_eleicoes.bens_candidato
	GROUP BY ano, titulo_eleitoral_candidato) bens 
ON candidatos.ano = bens.ano AND
candidatos.titulo_eleitoral = bens.titulo_eleitoral_candidato
LEFT JOIN(
	SELECT
	ano, 
	titulo_eleitoral_candidato,
	resultado,
	votos,
	FROM basedosdados.br_tse_eleicoes.resultados_candidato
	WHERE ano >= 2004 AND turno = 1) resultado 
ON candidatos.ano = resultado.ano AND 
candidatos.titulo_eleitoral = resultado.titulo_eleitoral_candidato

