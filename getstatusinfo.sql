CREATE OR REPLACE FUNCTION getstatusinfo(in selectedactvityid int4, in login_user_roleid int4, in resplogid int4, in statusids int4, in inputjson varchar, in lotid int4)
  RETURNS TABLE (statusid int4, description varchar, reasonrequired bool, nextapproval bool, fileprocess bool, allowdraft bool, isdefault int2) AS 
$BODY$

DECLARE valueid int;
begin
insert into assignmentpreelogs(fntext,created) select 'getstatusinfo'||$1::text||'/'||$2::text||'/'||$3::text||'/'||$4::text||'/'||coalesce($5::text,'')||'/'||$6::text,now();

If $1=796 and $5<>'null' and (select "value"  from (select $5 cl) as a cross join jsonb_to_recordset(a.cl::jsonb) as b("cpaRid" int,"value" text) where "cpaRid"='1657874')<>'' 
and (select "value"  from (select $5 cl) as a cross join jsonb_to_recordset(a.cl::jsonb) as b("cpaRid" int,"value" text) where "cpaRid"='1658195')='' 
then return query

select b.statusid,b.description,b.reasonrequired,b.nextapproval,b.fileprocess,b.allowdraft,a.is_default
from  tblstatus b 
inner join se_dcg_approval_role_status a on b.statusid=a.status_rid  and a.dcg_rid=$1
inner join se_dcg_approval_index c on c.dcg_ai_rid=a.dcg_ai_rid			 
where a.role_rid=$2 and b.statusid=3 limit 50;  


elsif $4<>1 then return query

select b.statusid,b.description,b.reasonrequired,b.nextapproval,b.fileprocess,b.allowdraft,a.is_default
from  tblstatus b 
inner join se_dcg_approval_role_status a on b.statusid=a.status_rid  and a.dcg_rid=$1
inner join se_dcg_approval_index c on c.dcg_ai_rid=a.dcg_ai_rid			 
where a.role_rid=$2;
end if;
end;


$BODY$
  LANGUAGE 'plpgsql' COST 100.0 SECURITY INVOKER