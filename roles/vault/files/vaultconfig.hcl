storage "mysql" {
address = "localhost:3306"
username = "{{ sweagle_mysql_user }}"
password = "{{ sweagle_mysql_password }}"
database = "{{ vault_backend_db | default('vault') }}"
scheme = "http"
}
listener "tcp" {
address = "{{ hostvars[inventory_hostname] }}:{{ vault_port | default(8200) }}"
tls_disable = 1
}
disable_mlock = true
