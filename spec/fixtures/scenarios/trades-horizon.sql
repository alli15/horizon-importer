--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

DROP INDEX public.unique_schema_migrations;
DROP INDEX public.index_history_transactions_on_id;
DROP INDEX public.index_history_transaction_statuses_lc_on_all;
DROP INDEX public.index_history_transaction_participants_on_transaction_hash;
DROP INDEX public.index_history_transaction_participants_on_account;
DROP INDEX public.index_history_operations_on_type;
DROP INDEX public.index_history_operations_on_transaction_id;
DROP INDEX public.index_history_operations_on_id;
DROP INDEX public.index_history_ledgers_on_sequence;
DROP INDEX public.index_history_ledgers_on_previous_ledger_hash;
DROP INDEX public.index_history_ledgers_on_ledger_hash;
DROP INDEX public.index_history_ledgers_on_id;
DROP INDEX public.index_history_ledgers_on_closed_at;
DROP INDEX public.index_history_effects_on_type;
DROP INDEX public.index_history_accounts_on_id;
DROP INDEX public.hs_transaction_by_id;
DROP INDEX public.hs_ledger_by_id;
DROP INDEX public.hist_op_p_id;
DROP INDEX public.hist_e_id;
DROP INDEX public.hist_e_by_order;
DROP INDEX public.by_status;
DROP INDEX public.by_ledger;
DROP INDEX public.by_hash;
DROP INDEX public.by_account;
ALTER TABLE ONLY public.history_transaction_statuses DROP CONSTRAINT history_transaction_statuses_pkey;
ALTER TABLE ONLY public.history_transaction_participants DROP CONSTRAINT history_transaction_participants_pkey;
ALTER TABLE ONLY public.history_operation_participants DROP CONSTRAINT history_operation_participants_pkey;
ALTER TABLE public.history_transaction_statuses ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.history_transaction_participants ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.history_operation_participants ALTER COLUMN id DROP DEFAULT;
DROP TABLE public.schema_migrations;
DROP TABLE public.history_transactions;
DROP SEQUENCE public.history_transaction_statuses_id_seq;
DROP TABLE public.history_transaction_statuses;
DROP SEQUENCE public.history_transaction_participants_id_seq;
DROP TABLE public.history_transaction_participants;
DROP TABLE public.history_operations;
DROP SEQUENCE public.history_operation_participants_id_seq;
DROP TABLE public.history_operation_participants;
DROP TABLE public.history_ledgers;
DROP TABLE public.history_effects;
DROP TABLE public.history_accounts;
DROP EXTENSION hstore;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: history_accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE history_accounts (
    id bigint NOT NULL,
    address character varying(64)
);


--
-- Name: history_effects; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE history_effects (
    history_account_id bigint NOT NULL,
    history_operation_id bigint NOT NULL,
    "order" integer NOT NULL,
    type integer NOT NULL,
    details jsonb
);


--
-- Name: history_ledgers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE history_ledgers (
    sequence integer NOT NULL,
    ledger_hash character varying(64) NOT NULL,
    previous_ledger_hash character varying(64),
    transaction_count integer DEFAULT 0 NOT NULL,
    operation_count integer DEFAULT 0 NOT NULL,
    closed_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id bigint
);


--
-- Name: history_operation_participants; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE history_operation_participants (
    id integer NOT NULL,
    history_operation_id bigint NOT NULL,
    history_account_id bigint NOT NULL
);


--
-- Name: history_operation_participants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE history_operation_participants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: history_operation_participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE history_operation_participants_id_seq OWNED BY history_operation_participants.id;


--
-- Name: history_operations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE history_operations (
    id bigint NOT NULL,
    transaction_id bigint NOT NULL,
    application_order integer NOT NULL,
    type integer NOT NULL,
    details jsonb
);


--
-- Name: history_transaction_participants; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE history_transaction_participants (
    id integer NOT NULL,
    transaction_hash character varying(64) NOT NULL,
    account character varying(64) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE history_transaction_participants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE history_transaction_participants_id_seq OWNED BY history_transaction_participants.id;


--
-- Name: history_transaction_statuses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE history_transaction_statuses (
    id integer NOT NULL,
    result_code_s character varying NOT NULL,
    result_code integer NOT NULL
);


--
-- Name: history_transaction_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE history_transaction_statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: history_transaction_statuses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE history_transaction_statuses_id_seq OWNED BY history_transaction_statuses.id;


--
-- Name: history_transactions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE history_transactions (
    transaction_hash character varying(64) NOT NULL,
    ledger_sequence integer NOT NULL,
    application_order integer NOT NULL,
    account character varying(64) NOT NULL,
    account_sequence bigint NOT NULL,
    max_fee integer NOT NULL,
    fee_paid integer NOT NULL,
    operation_count integer NOT NULL,
    transaction_status_id integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    id bigint
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY history_operation_participants ALTER COLUMN id SET DEFAULT nextval('history_operation_participants_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY history_transaction_participants ALTER COLUMN id SET DEFAULT nextval('history_transaction_participants_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY history_transaction_statuses ALTER COLUMN id SET DEFAULT nextval('history_transaction_statuses_id_seq'::regclass);


--
-- Data for Name: history_accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_accounts (id, address) FROM stdin;
0	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC
8589938688	gsbeJ7bWXqPHejmdEjRS46EViwMihoyMTJ42UJSTxWRez8nKxTe
8589942784	gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC
8589946880	gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe
8589950976	gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt
\.


--
-- Data for Name: history_effects; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_effects (history_account_id, history_operation_id, "order", type, details) FROM stdin;
8589938688	8589938688	0	0	{"starting_balance": 1000000000}
0	8589938688	1	3	{"amount": 1000000000, "currency_type": "native"}
8589942784	8589942784	0	0	{"starting_balance": 1000000000}
0	8589942784	1	3	{"amount": 1000000000, "currency_type": "native"}
8589946880	8589946880	0	0	{"starting_balance": 1000000000}
0	8589946880	1	3	{"amount": 1000000000, "currency_type": "native"}
8589950976	8589950976	0	0	{"starting_balance": 1000000000}
0	8589950976	1	3	{"amount": 1000000000, "currency_type": "native"}
8589938688	17179873280	0	2	{"amount": 5000000000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe"}
8589946880	17179873280	1	3	{"amount": 5000000000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe"}
8589942784	17179877376	0	2	{"amount": 5000000000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt"}
8589950976	17179877376	1	3	{"amount": 5000000000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt"}
\.


--
-- Data for Name: history_ledgers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_ledgers (sequence, ledger_hash, previous_ledger_hash, transaction_count, operation_count, closed_at, created_at, updated_at, id) FROM stdin;
1	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	\N	0	0	1970-01-01 00:00:00	2015-07-10 15:49:59.167852	2015-07-10 15:49:59.167852	4294967296
2	31c5550dc3021fa73c1d161dbd2209e7184bcf1cd4fdca06da57f44a9ac62ef8	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	4	4	2015-07-10 15:49:57	2015-07-10 15:49:59.179537	2015-07-10 15:49:59.179537	8589934592
3	8f9dbda5b902d6f9807227c7ab823f2caec984e713b0fe9eb665fe899d517e52	31c5550dc3021fa73c1d161dbd2209e7184bcf1cd4fdca06da57f44a9ac62ef8	4	4	2015-07-10 15:49:58	2015-07-10 15:49:59.27273	2015-07-10 15:49:59.27273	12884901888
4	50a543c96803976d26c689dc006e840b54987c583571a3f06807159680fb8ced	8f9dbda5b902d6f9807227c7ab823f2caec984e713b0fe9eb665fe899d517e52	2	2	2015-07-10 15:49:59	2015-07-10 15:49:59.314472	2015-07-10 15:49:59.314472	17179869184
5	dbb0d734e6aa866a94b5a46d24e892a89484a3c69913aed663a58888d387a136	50a543c96803976d26c689dc006e840b54987c583571a3f06807159680fb8ced	3	3	2015-07-10 15:50:00	2015-07-10 15:49:59.353859	2015-07-10 15:49:59.353859	21474836480
6	9615dde8fbc49859ae586e070c4bd9fda5912bcbe22923d76305464ef9095445	dbb0d734e6aa866a94b5a46d24e892a89484a3c69913aed663a58888d387a136	2	2	2015-07-10 15:50:01	2015-07-10 15:49:59.386504	2015-07-10 15:49:59.386504	25769803776
\.


--
-- Data for Name: history_operation_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operation_participants (id, history_operation_id, history_account_id) FROM stdin;
154	8589938688	0
155	8589938688	8589938688
156	8589942784	0
157	8589942784	8589942784
158	8589946880	0
159	8589946880	8589946880
160	8589950976	0
161	8589950976	8589950976
162	12884905984	8589938688
163	12884910080	8589942784
164	12884914176	8589938688
165	12884918272	8589942784
166	17179873280	8589938688
167	17179873280	8589946880
168	17179877376	8589942784
169	17179877376	8589950976
170	21474840576	8589942784
171	21474844672	8589942784
172	21474848768	8589942784
173	25769807872	8589938688
174	25769811968	8589938688
\.


--
-- Name: history_operation_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_operation_participants_id_seq', 174, true);


--
-- Data for Name: history_operations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_operations (id, transaction_id, application_order, type, details) FROM stdin;
8589938688	8589938688	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gsbeJ7bWXqPHejmdEjRS46EViwMihoyMTJ42UJSTxWRez8nKxTe", "starting_balance": 1000000000}
8589942784	8589942784	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC", "starting_balance": 1000000000}
8589946880	8589946880	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe", "starting_balance": 1000000000}
8589950976	8589950976	0	0	{"funder": "gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC", "account": "gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt", "starting_balance": 1000000000}
12884905984	12884905984	0	6	{"limit": 9223372036854775807, "trustee": "gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe", "trustor": "gsbeJ7bWXqPHejmdEjRS46EViwMihoyMTJ42UJSTxWRez8nKxTe", "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe"}
12884910080	12884910080	0	6	{"limit": 9223372036854775807, "trustee": "gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe", "trustor": "gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC", "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe"}
12884914176	12884914176	0	6	{"limit": 9223372036854775807, "trustee": "gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt", "trustor": "gsbeJ7bWXqPHejmdEjRS46EViwMihoyMTJ42UJSTxWRez8nKxTe", "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt"}
12884918272	12884918272	0	6	{"limit": 9223372036854775807, "trustee": "gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt", "trustor": "gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC", "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt"}
17179873280	17179873280	0	1	{"to": "gsbeJ7bWXqPHejmdEjRS46EViwMihoyMTJ42UJSTxWRez8nKxTe", "from": "gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe", "amount": 5000000000, "currency_code": "USD", "currency_type": "alphanum", "currency_issuer": "gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe"}
17179877376	17179877376	0	1	{"to": "gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC", "from": "gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt", "amount": 5000000000, "currency_code": "EUR", "currency_type": "alphanum", "currency_issuer": "gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt"}
21474840576	21474840576	0	3	{"price": {"d": 1, "n": 1}, "amount": 1000000000, "offer_id": 0}
21474844672	21474844672	0	3	{"price": {"d": 9, "n": 10}, "amount": 1111111111, "offer_id": 0}
21474848768	21474848768	0	3	{"price": {"d": 4, "n": 5}, "amount": 1250000000, "offer_id": 0}
25769807872	25769807872	0	3	{"price": {"d": 1, "n": 1}, "amount": 500000000, "offer_id": 0}
25769811968	25769811968	0	3	{"price": {"d": 1, "n": 1}, "amount": 500000000, "offer_id": 0}
\.


--
-- Data for Name: history_transaction_participants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_transaction_participants (id, transaction_hash, account, created_at, updated_at) FROM stdin;
136	0d157d6a9168256c37673a0a40b8da370c14cfc557b49d553ae2e477f2d9c73f	gsbeJ7bWXqPHejmdEjRS46EViwMihoyMTJ42UJSTxWRez8nKxTe	2015-07-10 15:49:59.184994	2015-07-10 15:49:59.184994
137	0d157d6a9168256c37673a0a40b8da370c14cfc557b49d553ae2e477f2d9c73f	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-10 15:49:59.186031	2015-07-10 15:49:59.186031
138	cf9b7c6aed81e0693830c48bb7a5c202022f3d681d5943211ff5a454a7b6324b	gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC	2015-07-10 15:49:59.211299	2015-07-10 15:49:59.211299
139	cf9b7c6aed81e0693830c48bb7a5c202022f3d681d5943211ff5a454a7b6324b	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-10 15:49:59.212308	2015-07-10 15:49:59.212308
140	d74aa7ebd1feff68ea38c362bb5dee25fc49cd3b44c24cedbdbfb4054f52510e	gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe	2015-07-10 15:49:59.230087	2015-07-10 15:49:59.230087
141	d74aa7ebd1feff68ea38c362bb5dee25fc49cd3b44c24cedbdbfb4054f52510e	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-10 15:49:59.231138	2015-07-10 15:49:59.231138
142	e8ce88562f60713f5ae518fede2d80e2c422623b2c13ec27c8b15c5cb471df74	gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt	2015-07-10 15:49:59.249006	2015-07-10 15:49:59.249006
143	e8ce88562f60713f5ae518fede2d80e2c422623b2c13ec27c8b15c5cb471df74	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2015-07-10 15:49:59.250063	2015-07-10 15:49:59.250063
144	83fe408700389dd511b838304acb8b0244ddd3873d9a51aa9a3204fd0a8db75a	gsbeJ7bWXqPHejmdEjRS46EViwMihoyMTJ42UJSTxWRez8nKxTe	2015-07-10 15:49:59.27745	2015-07-10 15:49:59.27745
145	ec2ace750d0a94a88eb4b0831424c089557ea42a57b4a35ab5f840ef61b691fe	gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC	2015-07-10 15:49:59.285687	2015-07-10 15:49:59.285687
146	ca9cee37a2c9a637e18a22c0ff86c0a2359fd620fc552994083b4214e53c071f	gsbeJ7bWXqPHejmdEjRS46EViwMihoyMTJ42UJSTxWRez8nKxTe	2015-07-10 15:49:59.293508	2015-07-10 15:49:59.293508
147	124ddf3b8e324e795edab3988696f3d0a43f51cb8370ea56d6bb20eb8ae9155b	gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC	2015-07-10 15:49:59.301091	2015-07-10 15:49:59.301091
148	57fb97c3edcc0971ccaa459694cd4cb9330116eef47cedbaf12b31a8d5e16978	gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe	2015-07-10 15:49:59.319	2015-07-10 15:49:59.319
149	4af308011e92a0c9345ba9364845be1c7f027b2d24bf9f16cd493acd81412b4f	gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt	2015-07-10 15:49:59.334185	2015-07-10 15:49:59.334185
150	bfbfd34092c15b02abf528b9d3c52066a8cc969ea91256ba468d1e2b89503455	gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC	2015-07-10 15:49:59.358491	2015-07-10 15:49:59.358491
151	1a3859d7e5feea23afe06371c6fc3f4dac92558a7301143660015fc8c19118f7	gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC	2015-07-10 15:49:59.366154	2015-07-10 15:49:59.366154
152	72a8fd22e864cd6a9934d5fd758312ea18d28ac6f6d45289d615ae45e8671dc5	gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC	2015-07-10 15:49:59.373653	2015-07-10 15:49:59.373653
153	bade0461ec4356acf5db0b010c8260f8595470e2c76a28d1fa0b8c7296ef7be2	gsbeJ7bWXqPHejmdEjRS46EViwMihoyMTJ42UJSTxWRez8nKxTe	2015-07-10 15:49:59.391243	2015-07-10 15:49:59.391243
154	a1b554358f63aea0f114700376a2eea187517aba948b990651948bcfff8fe7e5	gsbeJ7bWXqPHejmdEjRS46EViwMihoyMTJ42UJSTxWRez8nKxTe	2015-07-10 15:49:59.398693	2015-07-10 15:49:59.398693
\.


--
-- Name: history_transaction_participants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_transaction_participants_id_seq', 154, true);


--
-- Data for Name: history_transaction_statuses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_transaction_statuses (id, result_code_s, result_code) FROM stdin;
\.


--
-- Name: history_transaction_statuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('history_transaction_statuses_id_seq', 1, false);


--
-- Data for Name: history_transactions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY history_transactions (transaction_hash, ledger_sequence, application_order, account, account_sequence, max_fee, fee_paid, operation_count, transaction_status_id, created_at, updated_at, id) FROM stdin;
0d157d6a9168256c37673a0a40b8da370c14cfc557b49d553ae2e477f2d9c73f	2	1	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	1	10	10	1	-1	2015-07-10 15:49:59.183071	2015-07-10 15:49:59.183071	8589938688
cf9b7c6aed81e0693830c48bb7a5c202022f3d681d5943211ff5a454a7b6324b	2	2	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	2	10	10	1	-1	2015-07-10 15:49:59.209486	2015-07-10 15:49:59.209486	8589942784
d74aa7ebd1feff68ea38c362bb5dee25fc49cd3b44c24cedbdbfb4054f52510e	2	3	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	3	10	10	1	-1	2015-07-10 15:49:59.228119	2015-07-10 15:49:59.228119	8589946880
e8ce88562f60713f5ae518fede2d80e2c422623b2c13ec27c8b15c5cb471df74	2	4	gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	4	10	10	1	-1	2015-07-10 15:49:59.247217	2015-07-10 15:49:59.247217	8589950976
83fe408700389dd511b838304acb8b0244ddd3873d9a51aa9a3204fd0a8db75a	3	1	gsbeJ7bWXqPHejmdEjRS46EViwMihoyMTJ42UJSTxWRez8nKxTe	8589934593	10	10	1	-1	2015-07-10 15:49:59.27574	2015-07-10 15:49:59.27574	12884905984
ec2ace750d0a94a88eb4b0831424c089557ea42a57b4a35ab5f840ef61b691fe	3	2	gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC	8589934593	10	10	1	-1	2015-07-10 15:49:59.284105	2015-07-10 15:49:59.284105	12884910080
ca9cee37a2c9a637e18a22c0ff86c0a2359fd620fc552994083b4214e53c071f	3	3	gsbeJ7bWXqPHejmdEjRS46EViwMihoyMTJ42UJSTxWRez8nKxTe	8589934594	10	10	1	-1	2015-07-10 15:49:59.29189	2015-07-10 15:49:59.29189	12884914176
124ddf3b8e324e795edab3988696f3d0a43f51cb8370ea56d6bb20eb8ae9155b	3	4	gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC	8589934594	10	10	1	-1	2015-07-10 15:49:59.299443	2015-07-10 15:49:59.299443	12884918272
57fb97c3edcc0971ccaa459694cd4cb9330116eef47cedbaf12b31a8d5e16978	4	1	gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe	8589934593	10	10	1	-1	2015-07-10 15:49:59.31715	2015-07-10 15:49:59.31715	17179873280
4af308011e92a0c9345ba9364845be1c7f027b2d24bf9f16cd493acd81412b4f	4	2	gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt	8589934593	10	10	1	-1	2015-07-10 15:49:59.33248	2015-07-10 15:49:59.33248	17179877376
bfbfd34092c15b02abf528b9d3c52066a8cc969ea91256ba468d1e2b89503455	5	1	gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC	8589934595	10	10	1	-1	2015-07-10 15:49:59.356894	2015-07-10 15:49:59.356894	21474840576
1a3859d7e5feea23afe06371c6fc3f4dac92558a7301143660015fc8c19118f7	5	2	gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC	8589934596	10	10	1	-1	2015-07-10 15:49:59.364628	2015-07-10 15:49:59.364628	21474844672
72a8fd22e864cd6a9934d5fd758312ea18d28ac6f6d45289d615ae45e8671dc5	5	3	gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC	8589934597	10	10	1	-1	2015-07-10 15:49:59.371981	2015-07-10 15:49:59.371981	21474848768
bade0461ec4356acf5db0b010c8260f8595470e2c76a28d1fa0b8c7296ef7be2	6	1	gsbeJ7bWXqPHejmdEjRS46EViwMihoyMTJ42UJSTxWRez8nKxTe	8589934595	10	10	1	-1	2015-07-10 15:49:59.389362	2015-07-10 15:49:59.389362	25769807872
a1b554358f63aea0f114700376a2eea187517aba948b990651948bcfff8fe7e5	6	2	gsbeJ7bWXqPHejmdEjRS46EViwMihoyMTJ42UJSTxWRez8nKxTe	8589934596	10	10	1	-1	2015-07-10 15:49:59.397152	2015-07-10 15:49:59.397152	25769811968
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY schema_migrations (version) FROM stdin;
20150629181921
20150310224849
20150313225945
20150313225955
20150501160031
20150508003829
20150508175821
20150508183542
20150508215546
20150609230237
\.


--
-- Name: history_operation_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY history_operation_participants
    ADD CONSTRAINT history_operation_participants_pkey PRIMARY KEY (id);


--
-- Name: history_transaction_participants_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY history_transaction_participants
    ADD CONSTRAINT history_transaction_participants_pkey PRIMARY KEY (id);


--
-- Name: history_transaction_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY history_transaction_statuses
    ADD CONSTRAINT history_transaction_statuses_pkey PRIMARY KEY (id);


--
-- Name: by_account; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX by_account ON history_transactions USING btree (account, account_sequence);


--
-- Name: by_hash; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX by_hash ON history_transactions USING btree (transaction_hash);


--
-- Name: by_ledger; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX by_ledger ON history_transactions USING btree (ledger_sequence, application_order);


--
-- Name: by_status; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX by_status ON history_transactions USING btree (transaction_status_id);


--
-- Name: hist_e_by_order; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX hist_e_by_order ON history_effects USING btree (history_operation_id, "order");


--
-- Name: hist_e_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX hist_e_id ON history_effects USING btree (history_account_id, history_operation_id, "order");


--
-- Name: hist_op_p_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX hist_op_p_id ON history_operation_participants USING btree (history_account_id, history_operation_id);


--
-- Name: hs_ledger_by_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX hs_ledger_by_id ON history_ledgers USING btree (id);


--
-- Name: hs_transaction_by_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX hs_transaction_by_id ON history_transactions USING btree (id);


--
-- Name: index_history_accounts_on_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_history_accounts_on_id ON history_accounts USING btree (id);


--
-- Name: index_history_effects_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_history_effects_on_type ON history_effects USING btree (type);


--
-- Name: index_history_ledgers_on_closed_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_history_ledgers_on_closed_at ON history_ledgers USING btree (closed_at);


--
-- Name: index_history_ledgers_on_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_history_ledgers_on_id ON history_ledgers USING btree (id);


--
-- Name: index_history_ledgers_on_ledger_hash; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_history_ledgers_on_ledger_hash ON history_ledgers USING btree (ledger_hash);


--
-- Name: index_history_ledgers_on_previous_ledger_hash; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_history_ledgers_on_previous_ledger_hash ON history_ledgers USING btree (previous_ledger_hash);


--
-- Name: index_history_ledgers_on_sequence; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_history_ledgers_on_sequence ON history_ledgers USING btree (sequence);


--
-- Name: index_history_operations_on_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_history_operations_on_id ON history_operations USING btree (id);


--
-- Name: index_history_operations_on_transaction_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_history_operations_on_transaction_id ON history_operations USING btree (transaction_id);


--
-- Name: index_history_operations_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_history_operations_on_type ON history_operations USING btree (type);


--
-- Name: index_history_transaction_participants_on_account; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_history_transaction_participants_on_account ON history_transaction_participants USING btree (account);


--
-- Name: index_history_transaction_participants_on_transaction_hash; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_history_transaction_participants_on_transaction_hash ON history_transaction_participants USING btree (transaction_hash);


--
-- Name: index_history_transaction_statuses_lc_on_all; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_history_transaction_statuses_lc_on_all ON history_transaction_statuses USING btree (id, result_code, result_code_s);


--
-- Name: index_history_transactions_on_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_history_transactions_on_id ON history_transactions USING btree (id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM nullstyle;
GRANT ALL ON SCHEMA public TO nullstyle;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

