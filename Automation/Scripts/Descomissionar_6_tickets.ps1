# descomissionar_6tickets.ps1
# Executar no PowerShell 5.1+ / Windows 11

[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

# =======================
# Znuny / OTRS
# =======================
$ServerUrl = "http://172.31.49.49/znuny/nph-genericinterface.pl/Webservice/PyZabbix"
$User      = "evandro.santiago"
$Password  = Read-Host "Digite a senha do Znuny" -AsSecureString
$BSTR      = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
$PlainPass = [Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

# =======================
# Defaults do Ticket
# =======================
$State        = "Aberto"
$Priority     = "3 - Medio"
$Type         = "Solicitação de Serviço"
$CustomerUser = "evandro.santiago"

# =======================
# Tarefas
# =======================
$Tasks = @(
    @{
        Key       = "SEGURANCA_DA_INFORMACAO"
        Queue     = "GRU-OPERACAO-TI::GRU - SEGURANCA DA INFORMACAO"
        TitleTpl  = "Descomissionamento - {0} - Remoções Segurança"
        BodyTpl   = "Por favor remover o servidor {0} do Senhasegura, Sentinel, Qualys, Siem e Regras de Firewall"
    },
    @{
        Key       = "OBSERVABILIDADE"
        Queue     = "GRU-OPERACAO-TI::GRU - OBSERVABILIDADE"
        TitleTpl  = "Descomissionamento - {0} - Observabilidade"
        BodyTpl   = "Por favor remover do monitoramento e inventário o servidor {0}"
    },
    @{
        Key       = "BACKUP_E_RECUPERACAO"
        Queue     = "GRU-OPERACAO-TI::GRU - BACKUP E RECUPERACAO"
        TitleTpl  = "Descomissionamento - {0} - Último backup e remoção"
        BodyTpl   = "Realizar ultimo backup do servidor {0} e em seguida remover das rotinas."
    },
    @{
        Key       = "LINUX"
        Queue     = "GRU-OPERACAO-TI::GRU - LINUX"
        TitleTpl  = "Descomissionamento - {0} - Desativação"
        BodyTpl   = "Remover licenciamento e desativar o servidor {0}"
    },
    @{
        Key       = "MICROSOFT"
        Queue     = "GRU-OPERACAO-TI::GRU - MICROSOFT"
        TitleTpl  = "Descomissionamento - {0} - DNS"
        BodyTpl   = "Remover entradas DNS referentes ao servidor {0}"
    },
    @{
        Key       = "VIRTUALIZACAO"
        Queue     = "GRU-OPERACAO-TI::GRU - VIRTUALIZAÇÃO"
        TitleTpl  = "Descomissionamento - {0} - Remoção Vmware"
        BodyTpl   = "Bom dia, por favor remover servidor {0} após backup"
    }
)

function Read-ServerName {
    $server = Read-Host "Digite o nome do servidor para remoção"
    $server = $server.Trim()

    if ([string]::IsNullOrWhiteSpace($server)) {
        Write-Host "ERRO: nome do servidor vazio." -ForegroundColor Red
        exit 1
    }

    if ($server.Length -gt 100) {
        $server = $server.Substring(0,100)
    }

    return $server
}

function New-ZnunySession {
    param(
        [string]$Url,
        [string]$Username,
        [string]$Password
    )

    $payload = @{
        UserLogin = $Username
        Password  = $Password
    } | ConvertTo-Json -Depth 5

    try {
        $response = Invoke-RestMethod -Uri "$Url/Session" `
            -Method Post `
            -ContentType "application/json; charset=utf-8" `
            -Body $payload
        return $response
    }
    catch {
        Write-Host "ERRO: falha ao autenticar no Znuny. $_" -ForegroundColor Red
        exit 1
    }
}

function New-ZnunyTicket {
    param(
        [string]$Url,
        [string]$SessionID,
        [string]$Queue,
        [string]$Title,
        [string]$Body
    )

    $Title = if ($Title.Length -gt 200) { $Title.Substring(0,200) } else { $Title }

    $payload = @{
        SessionID = $SessionID
        Ticket    = @{
            State        = $State
            Priority     = $Priority
            Queue        = $Queue
            Title        = $Title
            CustomerUser = $CustomerUser
            Type         = $Type
        }
        Article   = @{
            Subject  = $Title
            Body     = $Body
            Charset  = "UTF8"
            MimeType = "text/plain"
        }
    } | ConvertTo-Json -Depth 10

    $response = Invoke-RestMethod -Uri "$Url/Ticket" `
        -Method Post `
        -ContentType "application/json; charset=utf-8" `
        -Body $payload

    return $response
}

# =======================
# MAIN
# =======================
$Server = Read-ServerName
$Session = New-ZnunySession -Url $ServerUrl -Username $User -Password $PlainPass

$SessionID = $null
if ($Session.SessionID) {
    $SessionID = $Session.SessionID
}
elseif ($Session.Data.SessionID) {
    $SessionID = $Session.Data.SessionID
}

if (-not $SessionID) {
    Write-Host "ERRO: sessão criada sem SessionID válido." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Abrindo 6 tickets para descomissionamento do servidor: $Server"
Write-Host ""

$Created = 0

foreach ($Task in $Tasks) {
    $Queue = $Task.Queue
    $Title = [string]::Format($Task.TitleTpl, $Server)
    $Body  = [string]::Format($Task.BodyTpl,  $Server)

    try {
        $TicketData = New-ZnunyTicket -Url $ServerUrl -SessionID $SessionID -Queue $Queue -Title $Title -Body $Body

        $TicketNumber = $null
        if ($TicketData.TicketNumber) {
            $TicketNumber = $TicketData.TicketNumber
        }
        elseif ($TicketData.Data.TicketNumber) {
            $TicketNumber = $TicketData.Data.TicketNumber
        }

        if ($TicketNumber) {
            Write-Host "$($Task.Key) -> Ticket criado: $TicketNumber - $Title"
            $Created++
        }
        else {
            Write-Host "[FALHA] $($Task.Key) | Queue='$Queue' | ERRO ao criar ticket (sem TicketNumber)." -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "[FALHA] $($Task.Key) | Queue='$Queue' | Erro: $_" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Resumo: $Created/6 tickets criados."