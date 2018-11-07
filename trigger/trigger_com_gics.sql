-- Function: daily.com_gics_stamp()

-- DROP FUNCTION daily.com_gics_stamp();

CREATE OR REPLACE FUNCTION daily.com_gics_stamp()
  RETURNS trigger AS
$BODY$
	DECLARE result character varying(20);	
	begin			
		select code into result from daily.com_gics where code = NEW.code and da = NEW.da;
		if result ISNULL then
			insert into daily.com_gics (code, da, gics_sector1) (select code, NEW.da, gics_sector1 from daily.com_gics where code = NEW.code order by da desc limit 1 );
		end if;	
		return NULL;
	end;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION daily.com_gics_stamp()
  OWNER TO postgres;

  
create trigger com_gics_stamp before update on daily.com_gics
	for each row execute procedure com_gics_stamp();
  