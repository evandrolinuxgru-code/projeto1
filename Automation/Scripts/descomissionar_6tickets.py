#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys
from pyotrs import Client
from pyotrs.lib import Ticket, Article
import getpass

# =======================
# Znuny / OTRS
# =======================
SERVER_URL = "http://172.31.49.49/znuny/nph-genericinterface.pl/Webservice/PyZabbix"
USER = "evandro.santiago"
PASSWORD = getpass.getpass("Digite a senha do Znuny: ")

# =======================
# Defaults do Ticket
# =======================
STATE = "Aberto"
PRIORITY = "3 - Medio"
TYPE = "Solicitação de Serviço"
CUSTOMER_USER = "evandro.santiago"

# =======================
# Tarefas (5 tickets / 5 filas)
# Ajuste os nomes de Queue se o seu Znuny usar outro caminho.
# =======================
TASKS = [
    {
        "key": "SEGURANCA_DA_INFORMACAO",
        "queue": "GRU-OPERACAO-TI::GRU - SEGURANCA DA INFORMACAO",
        "title_tpl": "Descomissionamento - {server} - Remoções Segurança",
        "body_tpl": "Por favor remover o servidor {server} do Senhasegura, Sentinel, Qualys, Siem e Regras de Firewall",
    },
    {
        "key": "OBSERVABILIDADE",
        "queue": "GRU-OPERACAO-TI::GRU - OBSERVABILIDADE",
        "title_tpl": "Descomissionamento - {server} - Observabilidade",
        "body_tpl": "Por favor remover do monitoramento e inventário o servidor {server}",
    },
    {
        "key": "BACKUP_E_RECUPERACAO",
        "queue": "GRU-OPERACAO-TI::GRU - BACKUP E RECUPERACAO",
        "title_tpl": "Descomissionamento - {server} - Último backup e remoção",
        "body_tpl": "Realizar ultimo backup do servidor {server} e em seguida remover das rotinas.",
    },
    {
        "key": "LINUX",
        "queue": "GRU-OPERACAO-TI::GRU - LINUX",
        "title_tpl": "Descomissionamento - {server} - Desativação",
        "body_tpl": "Remover licenciamento e desativar o servidor {server}",
    },
    {
        "key": "MICROSOFT",
        "queue": "GRU-OPERACAO-TI::GRU - MICROSOFT",
        "title_tpl": "Descomissionamento - {server} - DNS",
        "body_tpl": "Remover entradas DNS referentes ao servidor {server}",
    },
        {
        "key": "VIRTUALIZAÇÃO",
        "queue": "GRU-OPERACAO-TI::GRU - VIRTUALIZAÇÃO",
        "title_tpl": "Descomissionamento - {server} - Remoção Vmware",
        "body_tpl": "Bom dia, por favor remover servidor {server} após backup",
    },
]

def ler_servidor():
    server = input("Digite o nome do servidor para remoção: ").strip()
    if not server:
        print("ERRO: nome do servidor vazio.")
        sys.exit(1)
    return server[:100]

def criar_ticket(client, queue, title, body):
    t = Ticket.create_basic(
        State=STATE,
        Priority=PRIORITY,
        Queue=queue,
        Title=title[:200],
        CustomerUser=CUSTOMER_USER,
        Type=TYPE
    )

    a = Article({
        "Subject": title[:200],
        "Body": body,
        "Charset": "UTF8",
        "MimeType": "text/plain"
    })

    return client.ticket_create(t, a)

def main():
    server = ler_servidor()

    client = Client(SERVER_URL, USER, PASSWORD)
    if not client.session_create():
        print("ERRO: falha ao autenticar.")
        sys.exit(1)

    print(f"\nAbrindo 5 tickets para descomissionamento do servidor: {server}\n")

    criados = 0
    for task in TASKS:
        queue = task["queue"]
        title = task["title_tpl"].format(server=server)
        body = task["body_tpl"].format(server=server)

        try:
            ticket_data = criar_ticket(client, queue, title, body)
            ticket_number = ticket_data.get("TicketNumber")
        except Exception as e:
            print(f"[FALHA] {task['key']} | Queue='{queue}' | Erro: {e}")
            continue

        if ticket_number:
            print(f" {task['key']} -> Ticket criado: {ticket_number} - {title} ")
            criados += 1
        else:
            print(f"[FALHA] {task['key']} | Queue='{queue}' | ERRO ao criar ticket (sem TicketNumber).")

    print(f"\nResumo: {criados}/5 tickets criados.")

if __name__ == "__main__":
    main()