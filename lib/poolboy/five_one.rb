
class FiveOne

  def self.get_stats(mysql_conn)
    results ={}
    results['stats'] = mysql_conn.query("
    SELECT a.psize buffer_pool_mb, b.pageda pages_data,
    c.pagem pages_misc, d.pagef pages_free, e.pagesi page_size
    FROM (SELECT variable_value / 1024 / 1024 psize FROM GLOBAL_VARIABLES WHERE VARIABLE_NAME = 'INNODB_BUFFER_POOL_SIZE') a,
    (SELECT variable_value pageda FROM GLOBAL_STATUS WHERE VARIABLE_NAME = 'INNODB_BUFFER_POOL_PAGES_DATA') b,
    (SELECT variable_value pagem FROM GLOBAL_STATUS WHERE VARIABLE_NAME = 'INNODB_BUFFER_POOL_PAGES_MISC') c,
    (SELECT variable_value pagef FROM GLOBAL_STATUS WHERE VARIABLE_NAME = 'INNODB_BUFFER_POOL_PAGES_FREE') d,
    (SELECT variable_value pagesi FROM GLOBAL_VARIABLES WHERE VARIABLE_NAME = 'INNODB_PAGE_SIZE') e")

    results['bp'] = mysql_conn.query("
    SELECT `schema` AS db,
    innodb_sys_tables.name AS table_n,
    innodb_sys_indexes.name AS i_name,
    cnt,
    dirty,
    hashed,
    IFNULL(ROUND(cnt * 100 / index_s, 2),0) pct
    FROM (SELECT index_id,
    COUNT(*) cnt,
    SUM(dirty = 1) dirty, SUM(hashed = 1) hashed,
    data_size index_s
    FROM innodb_buffer_pool_pages_index
    GROUP BY index_id) bp
    JOIN innodb_sys_indexes ON bp.index_id = innodb_sys_indexes.id
    JOIN innodb_sys_tables ON innodb_sys_indexes.table_id = innodb_sys_tables.id
    JOIN innodb_index_stats ON innodb_index_stats.table_name = innodb_sys_tables.name
    AND innodb_sys_indexes.name = innodb_index_stats.index_name
    AND innodb_index_stats.table_schema = innodb_sys_tables.SCHEMA ORDER BY cnt DESC
    ")
    return results
  end

end