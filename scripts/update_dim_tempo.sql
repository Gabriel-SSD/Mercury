CREATE OR REPLACE PROCEDURE dw.update_dim_tempo()
 LANGUAGE plpgsql
AS $procedure$
	begin
		-- Insert dim_hora
		INSERT INTO dbo.dim_hora (sk_hora, hora, periodo)
		SELECT
		    CAST(REPLACE(sdh.hora, ':00', '') AS INTEGER),
		    CAST(REPLACE(sdh.hora, ':00', '') AS INTEGER),
		    sdh.periodo
		FROM stage.stg_dim_hora sdh
		ON CONFLICT DO NOTHING;

		-- Insert dim_data
		INSERT INTO dw.dim_data (sk_data, "date", "year", "month", "day", weekday, workday, holiday, holiday_name)
		SELECT
		    CAST(to_char(sdt."date"::timestamp, 'yyyymmdd') AS INTEGER),
		    sdt."date"::date,
		    sdt."year",
		    sdt."month",
		    sdt."day",
		    CASE
		        WHEN sdt.weekday = 'Monday' THEN 'Segunda'
		        WHEN sdt.weekday = 'Tuesday' THEN 'Terça'
		        WHEN sdt.weekday = 'Wednesday' THEN 'Quarta'
		        WHEN sdt.weekday = 'Thursday' THEN 'Quinta'
		        WHEN sdt.weekday = 'Friday' THEN 'Sexta'
		        WHEN sdt.weekday = 'Saturday' THEN 'Sábado'
		        WHEN sdt.weekday = 'Sunday' THEN 'Domingo'
		    END,
		    sdt.workday,
		    sdt.holiday,
		    sdt.holiday_name
		FROM stage.stg_dim_tempo sdt
		ON CONFLICT DO NOTHING;
	END;
$procedure$
;

-- Permissions

ALTER PROCEDURE dw.update_dim_tempo() OWNER TO "MercuryDBA";
GRANT ALL ON PROCEDURE dw.update_dim_tempo() TO "MercuryDBA";
