#variables.tf

subscription_id = "ec907711-acd7-4191-9983-9577afbe3ce1"
tenant_id       = "a2e466aa-4f86-4545-b5b8-97da7c8febf3"
client_id       = "01775374-4166-4be1-ba12-5cc3961c984b"
client_secret   = "yzb8Q~gPKCmWPMAL.QcbDwI7kEN7tshoVqxzVc6I"

resource_group_name = "opsia-rg-001"
prefix             = "opsia"
suffix             = "001"
location           = "North Europe"

node_count          = 2
admin_username      = "adminuser"
vm_size             = "Standard_DS2_v2"
kubernetes_version = "1.21.7"
azurerm_kubernetes_cluster = "opsai-akc"

db_admin_username = "gassim"
db_admin_password = "Gassim92!@"
db_username = "gassim"
db_password = "Gassim92!@"
app_image = "emotion-tracking"
