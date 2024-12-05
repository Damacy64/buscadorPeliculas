provider "azurerm" {
  features {}
  subscription_id = "62aeb70f-be33-47ad-ab46-87dc2a92010d" # Reemplaza con tu Subscription ID correcto
}

resource "azurerm_resource_group" "terraformyazure" {
  name     = "static-site-rg"                          # Nombre del grupo de recursos
  location = "South Central US"                        # Ubicación del grupo de recursos
}

resource "azurerm_storage_account" "ejemplopagina" {
  name                     = "staticwebstorage123"     # Nombre de la cuenta de almacenamiento
  resource_group_name      = azurerm_resource_group.terraformyazure.name
  location                 = azurerm_resource_group.terraformyazure.location
  account_tier             = "Standard"               # Nivel de cuenta (Standard o Premium)
  account_replication_type = "LRS"                    # Tipo de replicación (LRS, GRS, ZRS, etc.)
}

resource "azurerm_storage_account_static_website" "static_site" {
  storage_account_id = azurerm_storage_account.ejemplopagina.id

  index_document = "index.html"                       # Archivo principal del sitio
  error_404_document = "404.html"                    # Archivo para errores 404
}

# Subida de archivos HTML
resource "azurerm_storage_blob" "html_files" {
  for_each             = fileset("${path.module}/actividad8", "*.html")
  name                 = each.value
  storage_account_name = azurerm_storage_account.ejemplopagina.name
  storage_container_name = "$web"  # Contenedor de archivos estáticos
  type                 = "Block"
  source               = "${path.module}/actividad8/${each.value}"
  content_type         = "text/html"
}

# Subida de archivos CSS
resource "azurerm_storage_blob" "css_files" {
  for_each             = fileset("${path.module}/actividad8", "*.css")
  name                 = each.value
  storage_account_name = azurerm_storage_account.ejemplopagina.name
  storage_container_name = "$web"  # Contenedor de archivos estáticos
  type                 = "Block"
  source               = "${path.module}/actividad8/${each.value}"
  content_type         = "text/css"
}

# Subida de archivos JS
resource "azurerm_storage_blob" "js_files" {
  for_each             = fileset("${path.module}/actividad8", "*.js")
  name                 = each.value
  storage_account_name = azurerm_storage_account.ejemplopagina.name
  storage_container_name = "$web"  # Contenedor de archivos estáticos
  type                 = "Block"
  source               = "${path.module}/actividad8/${each.value}"
  content_type         = "application/javascript"
}

# Subida de archivos JPG/PNG (Imágenes)
resource "azurerm_storage_blob" "image_files" {
  for_each             = fileset("${path.module}/actividad8", "*.jpg")
  name                 = each.value
  storage_account_name = azurerm_storage_account.ejemplopagina.name
  storage_container_name = "$web"  # Contenedor de archivos estáticos
  type                 = "Block"
  source               = "${path.module}/actividad8/${each.value}"
  content_type         = "image/jpeg"
}

resource "azurerm_storage_blob" "image_png_files" {
  for_each             = fileset("${path.module}/actividad8", "*.png")
  name                 = each.value
  storage_account_name = azurerm_storage_account.ejemplopagina.name
  storage_container_name = "$web"  # Contenedor de archivos estáticos
  type                 = "Block"
  source               = "${path.module}/actividad8/${each.value}"
  content_type         = "image/png"
}

# Subida de archivos JSON
resource "azurerm_storage_blob" "json_files" {
  for_each             = fileset("${path.module}/actividad8", "*.json")
  name                 = each.value
  storage_account_name = azurerm_storage_account.ejemplopagina.name
  storage_container_name = "$web"  # Contenedor de archivos estáticos
  type                 = "Block"
  source               = "${path.module}/actividad8/${each.value}"
  content_type         = "application/json"
}

