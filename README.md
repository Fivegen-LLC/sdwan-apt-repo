# SD-WAN APT Repository

Централизованный APT репозиторий для всех пакетов SD-WAN проекта.

## 📦 Доступные пакеты

- `sdwan-agent` - Основной агент SD-WAN
- `sdwan-agent-orc` - Оркестратор агентов
- `sdwan-agent-starter` - Стартер для быстрого развертывания
- `sdwan-cli-ext` - CLI расширения
- `sdwan-update-manager` - Менеджер обновлений
- `sdwan-user-shell` - Пользовательская оболочка

## 🚀 Установка

### 1. Добавить GPG ключ репозитория

```bash
curl -sfLo /etc/apt/trusted.gpg.d/sdwan-apt-repo.asc https://fivegen-llc.github.io/sdwan-apt-repo/gpg.key
```

### 2. Добавить репозиторий в sources.list

```bash
echo "deb https://fivegen-llc.github.io/sdwan-apt-repo/ jammy main" | sudo tee /etc/apt/sources.list.d/sdwan-apt-repo.list
```

### 3. Обновить список пакетов

```bash
sudo apt update
```

### 4. Установить нужный пакет

```bash
# Установить основной агент
sudo apt install sdwan-agent

# Установить оркестратор
sudo apt install sdwan-agent-orc

# Установить стартер
sudo apt install sdwan-agent-starter

# Установить CLI расширения
sudo apt install sdwan-cli-ext

# Установить менеджер обновлений
sudo apt install sdwan-update-manager

# Установить пользовательскую оболочку
sudo apt install sdwan-user-shell
```

## 📋 Поддерживаемые архитектуры

- `amd64` (x86_64)
- `arm64` (aarch64)

## 🌐 URL репозитория

- **APT Repository**: https://fivegen-llc.github.io/sdwan-apt-repo/
- **GPG Key**: https://fivegen-llc.github.io/sdwan-apt-repo/gpg.key
