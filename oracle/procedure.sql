-- 存储过程
create or replace procedure p_update_village_catalog
(
v_hospitalid   in varchar2
,v_areaid       in varchar2
,v_drugdiagid   in varchar2
,i_current_year in int
,i_type         in int
,result         out int
) is
v_hospitalno varchar2(50);
v_area       varchar2(50);
i_year       int;
v_catalogid  varchar2(500);
begin
v_area       := v_areaid;
i_year       := i_current_year;
v_hospitalno := v_hospitalid;
v_catalogid  := v_drugdiagid;
--指定目录增加到指定县市下所有村室
if i_type = 1
then
insert into ncms_village_drug_diagnosis
select *
from (select sys_guid() as id
          ,v.code as code
          , --VARCHAR2(50)                                   药品、诊疗编码
             v.name as name
          , --VARCHAR2(250)                                  药品、诊疗名称
             v.en_name as en_name
          , --VARCHAR2(150) Y                                药品、诊疗英文名称
             v.type as type
          , --NUMBER(1)                                      药品、诊疗类型  0药品 1诊疗
             v.cost_type_code as cost_type_code
          , --VARCHAR2(20)                                   药品、诊疗费用类别编码
             v.drug_type_code as drug_type_code
          , --VARCHAR2(20)  Y                                药品类型编码^普药，藏药，苗药等,来自字典
             v.hospital_level_code as hospital_level_code
          , --VARCHAR2(20)  Y                                药品、诊疗使用医院级别编码
             v.spec as spec
          , --VARCHAR2(250) Y                                (药品、诊疗) 规格
             v.dosage as dosage
          , --VARCHAR2(250) Y                                (药品、诊疗) 剂型
             v.unit_code as unit
          , --VARCHAR2(250) Y                                (药品、诊疗) 单位编码
             v.percent as percent
          , --NUMBER(10,4)                                   (药品、诊疗) 保内比例
             v.basic_price as price
          , --NUMBER(12,6)  Y                                (药品、诊疗) 基准价格
             v.limit_price as limit_price
          , --NUMBER(12,6)  Y                                (药品) 最高限价
             v.basic_drug_prop_code as basic_drug_prop_code
          , --VARCHAR2(20)  Y                                (药品、诊疗) 基本药物属性编码
             v_area as area_id
          , --VARCHAR2(50)                                   (药品、诊疗) 地区编码
             v.pinyin_code as pinyin_code
          , --VARCHAR2(50)  Y                                (药品、诊疗) 拼音首拼码
             v.parent_id as parent_id
          , --VARCHAR2(50)  Y                                (药品、诊疗) 父ID
             v.gb_code as gb_code
          , --VARCHAR2(20)  Y                                上报编码
             v.timestamp as timestamp
          , --NUMBER(10)    Y                                (药品、诊疗) 时间戳
             v.active_time as active_time
          , --NUMBER(10)    Y                                (药品、诊疗) 生效时间
             time2int(sysdate) as update_time
          , --NUMBER(10)                                     (药品、诊疗) 更新时间
             'sysadmin' as updator
          , --VARCHAR2(50)  Y                                (药品、诊疗) 更新者
             v.status as status
          , --NUMBER(1)              1                       (药品、诊疗) 业务状态 0启用 1禁用
             v.remark as remark
          , --VARCHAR2(500) Y                                (药品、诊疗) 说明
             v.limit_price_village as limit_price_village
          , --NUMBER(12,6)  Y                                (诊疗)村级最高限价
             v.approve_min_price as approve_min_price
          , --NUMBER(12,6)  Y        0                       核准最低价格 默认为0
             v.is_pay as is_pay
          , --NUMBER(1)                                      是否可报销 1可报销 0不可报销
             v.is_stage as is_stage
          , --NUMBER(1)              0                       是否分段 0不分 1分段
             v.pharmacy_type as pharmacy_type
          , --NUMBER(1)     Y                                制药类型 0单方 1复方
             v.is_cms as is_cms
          , --NUMBER(1)              0                       是否农合办 0否 1是
             i_year as current_year
          , --NUMBER(4)              to_char(sysdate,'yyyy')
             v.flag as flag
          , --NUMBER(1)              0                       数据状态：0正常 1删除
             v.chinese_medicine_type as chinese_medicine_type
          , --VARCHAR2(20)  Y                                （药品）中药类型来自字典 （诊疗）是否中医项目：0 否 1是
             h.id as hospital_id
      from ncms_catalog_drug_diagnosis v, ncms_ins_hospital h
      where v.id = v_catalogid
        and h.flag = 0
        and h.is_village = 1
        and h.area_id like v_areaid || '%') m
where not exists (select 1
                  from ncms_village_drug_diagnosis d
                  where m.code = d.code
                    and m.hospital_id = d.hospital_id
                    and d.current_year = i_year);
commit;
--为某一个村室增加所有目录
else
if i_type = 2
then
merge into ncms_village_drug_diagnosis a
using (select sys_guid() as id
,v.code as code
, --VARCHAR2(50)                                   药品、诊疗编码
v.name as name
, --VARCHAR2(250)                                  药品、诊疗名称
v.en_name as en_name
, --VARCHAR2(150) Y                                药品、诊疗英文名称
v.type as type
, --NUMBER(1)                                      药品、诊疗类型  0药品 1诊疗
v.cost_type_code as cost_type_code
, --VARCHAR2(20)                                   药品、诊疗费用类别编码
v.drug_type_code as drug_type_code
, --VARCHAR2(20)  Y                                药品类型编码^普药，藏药，苗药等,来自字典
v.hospital_level_code as hospital_level_code
, --VARCHAR2(20)  Y                                药品、诊疗使用医院级别编码
v.spec as spec
, --VARCHAR2(250) Y                                (药品、诊疗) 规格
v.dosage as dosage
, --VARCHAR2(250) Y                                (药品、诊疗) 剂型
v.unit_code as unit
, --VARCHAR2(250) Y                                (药品、诊疗) 单位编码
v.percent as percent
, --NUMBER(10,4)                                   (药品、诊疗) 保内比例
v.basic_price as price
, --NUMBER(12,6)  Y                                (药品、诊疗) 基准价格
v.limit_price as limit_price
, --NUMBER(12,6)  Y                                (药品) 最高限价
v.basic_drug_prop_code as basic_drug_prop_code
, --VARCHAR2(20)  Y                                (药品、诊疗) 基本药物属性编码
v_area as area_id
, --VARCHAR2(50)                                   (药品、诊疗) 地区编码
v.pinyin_code as pinyin_code
, --VARCHAR2(50)  Y                                (药品、诊疗) 拼音首拼码
v.parent_id as parent_id
, --VARCHAR2(50)  Y                                (药品、诊疗) 父ID
v.gb_code as gb_code
, --VARCHAR2(20)  Y                                上报编码
v.timestamp as timestamp
, --NUMBER(10)    Y                                (药品、诊疗) 时间戳
v.active_time as active_time
, --NUMBER(10)    Y                                (药品、诊疗) 生效时间
time2int(sysdate) as update_time
, --NUMBER(10)                                     (药品、诊疗) 更新时间
'sysadmin' as updator
, --VARCHAR2(50)  Y                                (药品、诊疗) 更新者
v.status as status
, --NUMBER(1)              1                       (药品、诊疗) 业务状态 0启用 1禁用
v.remark as remark
, --VARCHAR2(500) Y                                (药品、诊疗) 说明
v.limit_price_village as limit_price_village
, --NUMBER(12,6)  Y                                (诊疗)村级最高限价
v.approve_min_price as approve_min_price
, --NUMBER(12,6)  Y        0                       核准最低价格 默认为0
v.is_pay as is_pay
, --NUMBER(1)                                      是否可报销 1可报销 0不可报销
v.is_stage as is_stage
, --NUMBER(1)              0                       是否分段 0不分 1分段
v.pharmacy_type as pharmacy_type
, --NUMBER(1)     Y                                制药类型 0单方 1复方
v.is_cms as is_cms
, --NUMBER(1)              0                       是否农合办 0否 1是
i_year as current_year
, --NUMBER(4)              to_char(sysdate,'yyyy')
v.flag as flag
, --NUMBER(1)              0                       数据状态：0正常 1删除
v.chinese_medicine_type as chinese_medicine_type
, --VARCHAR2(20)  Y                                （药品）中药类型来自字典 （诊疗）是否中医项目：0 否 1是
v_hospitalno as hospital_id
from ncms_catalog_drug_diagnosis v
where v.hospital_level_code like '%A%'
and v.flag = 0
and v.current_year = i_year
and v.area_id = v_area) t
on (a.code = t.code and a.area_id = t.area_id and a.flag = t.flag and a.current_year = t.current_year and a.hospital_id = t.hospital_id)
when not matched then
insert
(id
,code
,name
,en_name
,type
,cost_type_code
,drug_type_code
,hospital_level_code
,spec
,dosage
,unit
,percent
,price
,limit_price
,basic_drug_prop_code
,area_id
,pinyin_code
,parent_id
,gb_code
,timestamp
,active_time
,update_time
,updator
,status
,remark
,limit_price_village
,approve_min_price
,is_pay
,is_stage
,pharmacy_type
,is_cms
,current_year
,flag
,chinese_medicine_type
,hospital_id)
values
(t.id
,t.code
,t.name
,t.en_name
,t.type
,t.cost_type_code
,t.drug_type_code
,t.hospital_level_code
,t.spec
,t.dosage
,t.unit
,t.percent
,t.price
,t.limit_price
,t.basic_drug_prop_code
,t.area_id
,t.pinyin_code
,t.parent_id
,t.gb_code
,t.timestamp
,t.active_time
,t.update_time
,t.updator
,t.status
,t.remark
,t.limit_price_village
,t.approve_min_price
,t.is_pay
,t.is_stage
,t.pharmacy_type
,t.is_cms
,t.current_year
,t.flag
,t.chinese_medicine_type
,t.hospital_id);
commit;
else
null;
end if;
end if;
result := 0;
exception
when others then
rollback;
result := -1;
end p_update_village_catalog;
