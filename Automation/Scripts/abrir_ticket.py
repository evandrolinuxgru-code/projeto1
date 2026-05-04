#!/usr/bin/python3
# -*- coding: utf-8 -*-

import sys
from pyotrs import Client
from pyotrs.lib import Ticket, Article

# =======================
# Znuny / OTRS
# =======================
SERVER_URL = "http://172.31.49.49/znuny/nph-genericinterface.pl/Webservice/PyZabbix"
USER = "evandro.santiago"
PASSWORD = "Ecops@#$81904"

# =======================
# Filas disponíveis
# =======================
QUEUES = [
    "GRU-OPERACAO-TI::GRU - NOC",
    "GRU-OPERACAO-TI::GRU - LINUX",
    "GRU-OPERACAO-TI::GRU - VIRTUALIZAÇÃO",
    "GRU-OPERACAO-TI::GRU - DBA",
    "GRU-OPERACAO-TI::GRU - REDES",
    "GRU-OPERACAO-TI::GRU - SEGURANCA DA INFORMACAO",
    "GRU-OPERACAO-TI::GRU - BACKUP E RECUPERACAO",
    "GRU-OPERACAO-TI::GRU - OBSERVABILIDADE",
    "GRU-OPERACAO-TI::GRU - MICROSOFT"
]

STATE = "Aberto"
PRIORITY = "3 - Medio"
TYPE = "Solicitação de Serviço"
CUSTOMER_USER = "evandro.santiago"

def escolher_fila():
    print("Selecione a fila:")
    for i, q in enumerate(QUEUES, 1):
        print(f"{i} - {q}")
    try:
        opcao = int(input("Número: ").strip())
        return QUEUES[opcao - 1]
    except:
        print("Opção inválida.")
        sys.exit(1)

def ler_titulo():
    titulo = input("Digite o Título do chamado: ").strip()
    if not titulo:
        print("ERRO: título vazio.")
        sys.exit(1)
    return titulo[:200]

def ler_texto():
    print("Digite o corpo do chamado. Finalize com Ctrl+D:")
    body = sys.stdin.read().strip()
    if not body:
        print("ERRO: texto vazio.")
        sys.exit(1)
    return body

def main():
    queue = escolher_fila()
    title = ler_titulo()
    body = ler_texto()

    client = Client(SERVER_URL, USER, PASSWORD)

    if not client.session_create():
        print("ERRO: falha ao autenticar.")
        sys.exit(1)

    t = Ticket.create_basic(
        State=STATE,
        Priority=PRIORITY,
        Queue=queue,
        Title=title,
        CustomerUser=CUSTOMER_USER,
        Type=TYPE
    )

    a = Article({
        "Subject": title,
        "Body": body,
        "Charset": "UTF8",
        "MimeType": "text/plain"
    })

    ticket_data = client.ticket_create(t, a)
    ticket_number = ticket_data.get("TicketNumber")

    if ticket_number:
        print(f"Ticket criado: {ticket_number}")
    else:
        print("ERRO ao criar ticket.")
        sys.exit(1)

if __name__ == "__main__":
    main()
