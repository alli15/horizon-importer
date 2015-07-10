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

DROP INDEX public.signersaccount;
DROP INDEX public.priceindex;
DROP INDEX public.paysissuerindex;
DROP INDEX public.ledgersbyseq;
DROP INDEX public.getsissuerindex;
DROP INDEX public.accountlines;
DROP INDEX public.accountbalances;
ALTER TABLE ONLY public.txhistory DROP CONSTRAINT txhistory_pkey;
ALTER TABLE ONLY public.txhistory DROP CONSTRAINT txhistory_ledgerseq_txindex_key;
ALTER TABLE ONLY public.trustlines DROP CONSTRAINT trustlines_pkey;
ALTER TABLE ONLY public.storestate DROP CONSTRAINT storestate_pkey;
ALTER TABLE ONLY public.signers DROP CONSTRAINT signers_pkey;
ALTER TABLE ONLY public.peers DROP CONSTRAINT peers_pkey;
ALTER TABLE ONLY public.offers DROP CONSTRAINT offers_pkey;
ALTER TABLE ONLY public.ledgerheaders DROP CONSTRAINT ledgerheaders_pkey;
ALTER TABLE ONLY public.ledgerheaders DROP CONSTRAINT ledgerheaders_ledgerseq_key;
ALTER TABLE ONLY public.accounts DROP CONSTRAINT accounts_pkey;
DROP TABLE public.txhistory;
DROP TABLE public.trustlines;
DROP TABLE public.storestate;
DROP TABLE public.signers;
DROP TABLE public.peers;
DROP TABLE public.offers;
DROP TABLE public.ledgerheaders;
DROP TABLE public.accounts;
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


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    accountid character varying(51) NOT NULL,
    balance bigint NOT NULL,
    seqnum bigint NOT NULL,
    numsubentries integer NOT NULL,
    inflationdest character varying(51),
    homedomain character varying(32),
    thresholds text,
    flags integer NOT NULL,
    CONSTRAINT accounts_balance_check CHECK ((balance >= 0)),
    CONSTRAINT accounts_numsubentries_check CHECK ((numsubentries >= 0))
);


--
-- Name: ledgerheaders; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE ledgerheaders (
    ledgerhash character(64) NOT NULL,
    prevhash character(64) NOT NULL,
    bucketlisthash character(64) NOT NULL,
    ledgerseq integer,
    closetime bigint NOT NULL,
    data text NOT NULL,
    CONSTRAINT ledgerheaders_closetime_check CHECK ((closetime >= 0)),
    CONSTRAINT ledgerheaders_ledgerseq_check CHECK ((ledgerseq >= 0))
);


--
-- Name: offers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE offers (
    accountid character varying(51) NOT NULL,
    offerid bigint NOT NULL,
    paysalphanumcurrency character varying(4),
    paysissuer character varying(51),
    getsalphanumcurrency character varying(4),
    getsissuer character varying(51),
    amount bigint NOT NULL,
    pricen integer NOT NULL,
    priced integer NOT NULL,
    price bigint NOT NULL,
    flags integer NOT NULL,
    CONSTRAINT offers_amount_check CHECK ((amount >= 0)),
    CONSTRAINT offers_offerid_check CHECK ((offerid >= 0))
);


--
-- Name: peers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE peers (
    ip character varying(15) NOT NULL,
    port integer DEFAULT 0 NOT NULL,
    nextattempt timestamp without time zone NOT NULL,
    numfailures integer DEFAULT 0 NOT NULL,
    rank integer DEFAULT 0 NOT NULL,
    CONSTRAINT peers_numfailures_check CHECK ((numfailures >= 0)),
    CONSTRAINT peers_port_check CHECK (((port > 0) AND (port <= 65535))),
    CONSTRAINT peers_rank_check CHECK ((rank >= 0))
);


--
-- Name: signers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE signers (
    accountid character varying(51) NOT NULL,
    publickey character varying(51) NOT NULL,
    weight integer NOT NULL
);


--
-- Name: storestate; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE storestate (
    statename character(32) NOT NULL,
    state text
);


--
-- Name: trustlines; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trustlines (
    accountid character varying(51) NOT NULL,
    issuer character varying(51) NOT NULL,
    alphanumcurrency character varying(4) NOT NULL,
    tlimit bigint DEFAULT 0 NOT NULL,
    balance bigint DEFAULT 0 NOT NULL,
    flags integer NOT NULL,
    CONSTRAINT trustlines_balance_check CHECK ((balance >= 0)),
    CONSTRAINT trustlines_tlimit_check CHECK ((tlimit >= 0))
);


--
-- Name: txhistory; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE txhistory (
    txid character(64) NOT NULL,
    ledgerseq integer NOT NULL,
    txindex integer NOT NULL,
    txbody text NOT NULL,
    txresult text NOT NULL,
    txmeta text NOT NULL,
    CONSTRAINT txhistory_ledgerseq_check CHECK ((ledgerseq >= 0))
);


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY accounts (accountid, balance, seqnum, numsubentries, inflationdest, homedomain, thresholds, flags) FROM stdin;
gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	99999995999999960	4	0	\N		01000000	0
gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe	999999990	8589934593	0	\N		01000000	0
gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt	999999990	8589934593	0	\N		01000000	0
gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC	999999950	8589934597	5	\N		01000000	0
gsbeJ7bWXqPHejmdEjRS46EViwMihoyMTJ42UJSTxWRez8nKxTe	999999960	8589934596	3	\N		01000000	0
\.


--
-- Data for Name: ledgerheaders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ledgerheaders (ledgerhash, prevhash, bucketlisthash, ledgerseq, closetime, data) FROM stdin;
e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	0000000000000000000000000000000000000000000000000000000000000000	366ab1da319554c51293d7cbf7893a2373dbb0adb73bc8f86d4842995a948be6	1	0	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA2arHaMZVUxRKT18v3iTojc9uwrbc7yPhtSEKZWpSL5gAAAAEBY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
31c5550dc3021fa73c1d161dbd2209e7184bcf1cd4fdca06da57f44a9ac62ef8	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	09117db73fe145141ea98785b1644171fc5ae297254bcbd3a4bdb511a7ce1c3d	2	1436543397	AAAAAejhCRj5wADHMRmr5UzwifWfkBXMk8SczwC16Lmvtuax3AXI6kwuTJTKObhIH1q6kzEVdwVSOqBBXnzeme3QHyAAAAAAVZ/ppQAAAAEAAAAIAAAAAQAAAAEAAAAARjDfX4IXx2WfwI55clqhWfbu7boRdnUkKlN/ozlaRWMJEX23P+FFFB6ph4WxZEFx/FrilyVLy9OkvbURp84cPQAAAAIBY0V4XYoAAAAAAAAAAAAoAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
8f9dbda5b902d6f9807227c7ab823f2caec984e713b0fe9eb665fe899d517e52	31c5550dc3021fa73c1d161dbd2209e7184bcf1cd4fdca06da57f44a9ac62ef8	4897fba3072f2e42cf30c8c6e6fe002ff6422404bf73330517cda7cb622e2e21	3	1436543398	AAAAATHFVQ3DAh+nPB0WHb0iCecYS88c1P3KBtpX9Eqaxi74iEjg6y53m/VaSie0eX0eMOYx1zXgTqX5iLGSVN+7EgEAAAAAVZ/ppgAAAAAAAAAACG8P/IEnS9MOBBIZUUVLld+5XBHHF96TqoiQs2GNdrZIl/ujBy8uQs8wyMbm/gAv9kIkBL9zMwUXzafLYi4uIQAAAAMBY0V4XYoAAAAAAAAAAABQAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
50a543c96803976d26c689dc006e840b54987c583571a3f06807159680fb8ced	8f9dbda5b902d6f9807227c7ab823f2caec984e713b0fe9eb665fe899d517e52	2f87356ab15efff3d37a7268be2f1d3897a7ba5007642ca2155014a9af63d0ee	4	1436543399	AAAAAY+dvaW5Atb5gHInx6uCPyyuyYTnE7D+nrZl/omdUX5SvB4nbLnuNMO6mEWzbPBCn5GmqDEcRPZ/R1W8HSGApFQAAAAAVZ/ppwAAAAAAAAAABfQUG2P8786Qnr6AcRUHHM3mbM0ppiFPLbqDDrv53FMvhzVqsV7/89N6cmi+Lx04l6e6UAdkLKIVUBSpr2PQ7gAAAAQBY0V4XYoAAAAAAAAAAABkAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
dbb0d734e6aa866a94b5a46d24e892a89484a3c69913aed663a58888d387a136	50a543c96803976d26c689dc006e840b54987c583571a3f06807159680fb8ced	3f10d817319160b5cdb2b33c72f1f80a45e5c9cee77f28d47289811c2957cb4e	5	1436543400	AAAAAVClQ8loA5dtJsaJ3ABuhAtUmHxYNXGj8GgHFZaA+4zt//N+TVsh92doOE2XhrRumjRY8mPXVYW3lMETFQG0MxoAAAAAVZ/pqAAAAAAAAAAADw2HGLE5ttOxnilrHdROzSqM+SgFydpNv/dwVPyLW24/ENgXMZFgtc2yszxy8fgKReXJzud/KNRyiYEcKVfLTgAAAAUBY0V4XYoAAAAAAAAAAACCAAAAAAAAAAAAAAADAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
9615dde8fbc49859ae586e070c4bd9fda5912bcbe22923d76305464ef9095445	dbb0d734e6aa866a94b5a46d24e892a89484a3c69913aed663a58888d387a136	0559f2f2c64a2f7f9e3ce17d00332701600b70340b650de3fa3479e31169086b	6	1436543401	AAAAAduw1zTmqoZqlLWkbSTokqiUhKPGmROu1mOliIjTh6E2FVnAZLLQkOr9F8hFi7m1Lxi7dnEDoPSSckehEmlsHSMAAAAAVZ/pqQAAAAAAAAAAMnO1XFhqspaR82iTaDvJ2BYpFgjJ90UQAJZYnwKjGToFWfLyxkovf5484X0AMycBYAtwNAtlDeP6NHnjEWkIawAAAAYBY0V4XYoAAAAAAAAAAACWAAAAAAAAAAAAAAAEAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
\.


--
-- Data for Name: offers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY offers (accountid, offerid, paysalphanumcurrency, paysissuer, getsalphanumcurrency, getsissuer, amount, pricen, priced, price, flags) FROM stdin;
gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC	2	USD	gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe	EUR	gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt	1111111111	10	9	11111111	0
gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC	3	USD	gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe	EUR	gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt	1250000000	5	4	12500000	0
gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC	1	USD	gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe	EUR	gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt	500000000	1	1	10000000	0
gsbeJ7bWXqPHejmdEjRS46EViwMihoyMTJ42UJSTxWRez8nKxTe	4	\N	\N	USD	gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe	500000000	1	1	10000000	0
\.


--
-- Data for Name: peers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY peers (ip, port, nextattempt, numfailures, rank) FROM stdin;
\.


--
-- Data for Name: signers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY signers (accountid, publickey, weight) FROM stdin;
\.


--
-- Data for Name: storestate; Type: TABLE DATA; Schema: public; Owner: -
--

COPY storestate (statename, state) FROM stdin;
databaseinitialized             	true
forcescponnextlaunch            	false
lastclosedledger                	9615dde8fbc49859ae586e070c4bd9fda5912bcbe22923d76305464ef9095445
historyarchivestate             	{\n    "version": 0,\n    "currentLedger": 6,\n    "currentBuckets": [\n        {\n            "curr": "24557e1d732c13994c927ece455bfa33a5e3aa5c27071171dc01c51272bed4d2",\n            "next": {\n                "state": 0\n            },\n            "snap": "85828e82777ba96d49aa5d40672a2bfaed32821614793439cfec81ac5dc1688e"\n        },\n        {\n            "curr": "80302a11d4cb822e662e45916f8e362946431ab0433d18bffd6ab215f90ed3b1",\n            "next": {\n                "state": 1,\n                "output": "85828e82777ba96d49aa5d40672a2bfaed32821614793439cfec81ac5dc1688e"\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        }\n    ]\n}
\.


--
-- Data for Name: trustlines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trustlines (accountid, issuer, alphanumcurrency, tlimit, balance, flags) FROM stdin;
gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC	gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe	USD	9223372036854775807	500000000	1
gUDmfqqfLTqsHD8A91tquDFDc4LpM8gd9EuiRqHbrZ61fg6QXC	gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt	EUR	9223372036854775807	4500000000	1
gsbeJ7bWXqPHejmdEjRS46EViwMihoyMTJ42UJSTxWRez8nKxTe	gssBsGVzUPFAAk2thayDPQvSEh7u67JeXZqsWfszXRkVJLBYdXt	EUR	9223372036854775807	500000000	1
gsbeJ7bWXqPHejmdEjRS46EViwMihoyMTJ42UJSTxWRez8nKxTe	gsKS5UiqeGRyYfiwcxvRs4okdj9MDd7PVtebTRw7dQwpBPZ6Dwe	USD	9223372036854775807	4500000000	1
\.


--
-- Data for Name: txhistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY txhistory (txid, ledgerseq, txindex, txbody, txresult, txmeta) FROM stdin;
0d157d6a9168256c37673a0a40b8da370c14cfc557b49d553ae2e477f2d9c73f	2	1	AAAAAImbKEDtVjbFbdxfFLI5dfefG6I4jSaU5MVuzd3JYOXvAAAACgAAAAAAAAABAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAA0luIc6YNVw9cd3tPg5cygYBdaNPBkydzYAOefbL+eIsAAAAAO5rKAAAAAAAAAAAByWDl7wAAAEAQVTkSrJ3XTPpzSVy4QW/Y0nH/cZaS3+iZndNjFlhwMUvuJN513LolG0+DJW/EgYgs2osndFrVLjxOoY+Z5w0D	DRV9apFoJWw3ZzoKQLjaNwwUz8VXtJ1VOuLkd/LZxz8AAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAgAAAAAAAAAAAAAAANJbiHOmDVcPXHd7T4OXMoGAXWjTwZMnc2ADnn2y/niLAAAAADuaygAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAABAAAAAAAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXgh7zX2AAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
cf9b7c6aed81e0693830c48bb7a5c202022f3d681d5943211ff5a454a7b6324b	2	2	AAAAAImbKEDtVjbFbdxfFLI5dfefG6I4jSaU5MVuzd3JYOXvAAAACgAAAAAAAAACAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAGXn140vcYvacR0CtKHq9BRpUZDQFgoY6m7lnAnwetlcAAAAAO5rKAAAAAAAAAAAByWDl7wAAAEAFq/G6O6l+MxfiBpLZ4ezH1xsf090N/1IF5C9Sadn/7gYh8SqLoTBMqPQ8l7jgLL02JkCFMPHYrMI9Son83WAE	z5t8au2B4Gk4MMSLt6XCAgIvPWgdWUMhH/WkVKe2MksAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAgAAAAAAAAAAAAAAABl59eNL3GL2nEdArSh6vQUaVGQ0BYKGOpu5ZwJ8HrZXAAAAADuaygAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAABAAAAAAAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXfmVGvsAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
d74aa7ebd1feff68ea38c362bb5dee25fc49cd3b44c24cedbdbfb4054f52510e	2	3	AAAAAImbKEDtVjbFbdxfFLI5dfefG6I4jSaU5MVuzd3JYOXvAAAACgAAAAAAAAADAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAArZLmQRKBqoi+67bp4TzRzJFRtltVV0KuawhdK8tEq/wAAAAAO5rKAAAAAAAAAAAByWDl7wAAAEAtZ+LLiXw8uZfulqquLX/zYSYe2cZ9FDlD8E0VZ4Q3c9yHKEiwE8zeYAXzVEwHqLKkZUTZy6yOtH0JS+v7on0F	10qn69H+/2jqOMNiu13uJfxJzTtEwkztvb+0BU9SUQ4AAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAgAAAAAAAAAAAAAAAK2S5kESgaqIvuu26eE80cyRUbZbVVdCrmsIXSvLRKv8AAAAADuaygAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAABAAAAAAAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXequaHiAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
e8ce88562f60713f5ae518fede2d80e2c422623b2c13ec27c8b15c5cb471df74	2	4	AAAAAImbKEDtVjbFbdxfFLI5dfefG6I4jSaU5MVuzd3JYOXvAAAACgAAAAAAAAAEAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAhlvrVLT1deNs52ykyqEJWYYeazSU3EF/HScICdAhmfEAAAAAO5rKAAAAAAAAAAAByWDl7wAAAECj4bdgEIxBUKjkjPQ8AZ7nJXqAxoV9+xj10HwZBdCvSTITflSgUD1mS6p3JrWP7q1dMKMyiV4WYQGAUPMjHSkI	6M6IVi9gcT9a5Rj+3i2A4sQiYjssE+wnyLFcXLRx33QAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAgAAAAAAAAAAAAAAAIZb61S09XXjbOdspMqhCVmGHms0lNxBfx0nCAnQIZnxAAAAADuaygAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAABAAAAAAAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXdvHtfYAAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
83fe408700389dd511b838304acb8b0244ddd3873d9a51aa9a3204fd0a8db75a	3	1	AAAAANJbiHOmDVcPXHd7T4OXMoGAXWjTwZMnc2ADnn2y/niLAAAACgAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABVVNEAAAAAACtkuZBEoGqiL7rtunhPNHMkVG2W1VXQq5rCF0ry0Sr/H//////////AAAAAAAAAAGy/niLAAAAQOLB9dsDocWqy+H6C0449Lyq9pE0ltUd5tIlXbqrm1UKXyK7Q2BSCSMzf3pGSH8xglnDKmWrmrlLFyLVo4GBkQo=	g/5AhwA4ndURuDgwSsuLAkTd04c9mlGqmjIE/QqNt1oAAAAAAAAACgAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==	AAAAAgAAAAAAAAABAAAAANJbiHOmDVcPXHd7T4OXMoGAXWjTwZMnc2ADnn2y/niLAAAAAVVTRAAAAAAArZLmQRKBqoi+67bp4TzRzJFRtltVV0KuawhdK8tEq/wAAAAAAAAAAH//////////AAAAAQAAAAAAAAABAAAAAAAAAADSW4hzpg1XD1x3e0+DlzKBgF1o08GTJ3NgA559sv54iwAAAAA7msn2AAAAAgAAAAEAAAABAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
ec2ace750d0a94a88eb4b0831424c089557ea42a57b4a35ab5f840ef61b691fe	3	2	AAAAABl59eNL3GL2nEdArSh6vQUaVGQ0BYKGOpu5ZwJ8HrZXAAAACgAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABVVNEAAAAAACtkuZBEoGqiL7rtunhPNHMkVG2W1VXQq5rCF0ry0Sr/H//////////AAAAAAAAAAF8HrZXAAAAQE44eM+UJ0GFJMFO9MybqjVdDkEPgA5PmFB1bIdqY1aeE0DRqbVUErKd9I2tnJwIux5/8V8xWwvFKfr/nedn1Aw=	7CrOdQ0KlKiOtLCDFCTAiVV+pCpXtKNatfhA72G2kf4AAAAAAAAACgAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==	AAAAAgAAAAAAAAABAAAAABl59eNL3GL2nEdArSh6vQUaVGQ0BYKGOpu5ZwJ8HrZXAAAAAVVTRAAAAAAArZLmQRKBqoi+67bp4TzRzJFRtltVV0KuawhdK8tEq/wAAAAAAAAAAH//////////AAAAAQAAAAAAAAABAAAAAAAAAAAZefXjS9xi9pxHQK0oer0FGlRkNAWChjqbuWcCfB62VwAAAAA7msn2AAAAAgAAAAEAAAABAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
ca9cee37a2c9a637e18a22c0ff86c0a2359fd620fc552994083b4214e53c071f	3	3	AAAAANJbiHOmDVcPXHd7T4OXMoGAXWjTwZMnc2ADnn2y/niLAAAACgAAAAIAAAACAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABRVVSAAAAAACGW+tUtPV142znbKTKoQlZhh5rNJTcQX8dJwgJ0CGZ8X//////////AAAAAAAAAAGy/niLAAAAQAa9ILt2SBFGuVXpxVegU6xBmpvShrzpeRNmv0uC2IrZpjQCTYhTHGUgJKCSETWepPWgkwBYzA1fEOJ3+UXeEQo=	ypzuN6LJpjfhiiLA/4bAojWf1iD8VSmUCDtCFOU8Bx8AAAAAAAAACgAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==	AAAAAgAAAAAAAAABAAAAANJbiHOmDVcPXHd7T4OXMoGAXWjTwZMnc2ADnn2y/niLAAAAAUVVUgAAAAAAhlvrVLT1deNs52ykyqEJWYYeazSU3EF/HScICdAhmfEAAAAAAAAAAH//////////AAAAAQAAAAAAAAABAAAAAAAAAADSW4hzpg1XD1x3e0+DlzKBgF1o08GTJ3NgA559sv54iwAAAAA7msnsAAAAAgAAAAIAAAACAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
124ddf3b8e324e795edab3988696f3d0a43f51cb8370ea56d6bb20eb8ae9155b	3	4	AAAAABl59eNL3GL2nEdArSh6vQUaVGQ0BYKGOpu5ZwJ8HrZXAAAACgAAAAIAAAACAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABRVVSAAAAAACGW+tUtPV142znbKTKoQlZhh5rNJTcQX8dJwgJ0CGZ8X//////////AAAAAAAAAAF8HrZXAAAAQDtDRot0pXg67ybzCnHI0gwbZaZEeD7uFFGIfKLKpPBNuHOSlnpN2juP20fK8CzlOX5Qi7eIIpVsEKUQqAAdkwA=	Ek3fO44yTnle2rOYhpbz0KQ/UcuDcOpW1rsg64rpFVsAAAAAAAAACgAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==	AAAAAgAAAAAAAAABAAAAABl59eNL3GL2nEdArSh6vQUaVGQ0BYKGOpu5ZwJ8HrZXAAAAAUVVUgAAAAAAhlvrVLT1deNs52ykyqEJWYYeazSU3EF/HScICdAhmfEAAAAAAAAAAH//////////AAAAAQAAAAAAAAABAAAAAAAAAAAZefXjS9xi9pxHQK0oer0FGlRkNAWChjqbuWcCfB62VwAAAAA7msnsAAAAAgAAAAIAAAACAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
57fb97c3edcc0971ccaa459694cd4cb9330116eef47cedbaf12b31a8d5e16978	4	1	AAAAAK2S5kESgaqIvuu26eE80cyRUbZbVVdCrmsIXSvLRKv8AAAACgAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAEAAAAA0luIc6YNVw9cd3tPg5cygYBdaNPBkydzYAOefbL+eIsAAAABVVNEAAAAAACtkuZBEoGqiL7rtunhPNHMkVG2W1VXQq5rCF0ry0Sr/AAAAAEqBfIAAAAAAAAAAAHLRKv8AAAAQByWVH6x+3DhWr86no95Tix8QDEtDP+QRYGphMpLeHLUUdPDseDF/G3p3gtjIPrUKwMtx745Nd65DJBuhwfb4Ak=	V/uXw+3MCXHMqkWWlM1MuTMBFu70fO268SsxqNXhaXgAAAAAAAAACgAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAA==	AAAAAgAAAAEAAAAAAAAAAK2S5kESgaqIvuu26eE80cyRUbZbVVdCrmsIXSvLRKv8AAAAADuayfYAAAACAAAAAQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAABAAAAAQAAAADSW4hzpg1XD1x3e0+DlzKBgF1o08GTJ3NgA559sv54iwAAAAFVU0QAAAAAAK2S5kESgaqIvuu26eE80cyRUbZbVVdCrmsIXSvLRKv8AAAAASoF8gB//////////wAAAAEAAAAA
4af308011e92a0c9345ba9364845be1c7f027b2d24bf9f16cd493acd81412b4f	4	2	AAAAAIZb61S09XXjbOdspMqhCVmGHms0lNxBfx0nCAnQIZnxAAAACgAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAEAAAAAGXn140vcYvacR0CtKHq9BRpUZDQFgoY6m7lnAnwetlcAAAABRVVSAAAAAACGW+tUtPV142znbKTKoQlZhh5rNJTcQX8dJwgJ0CGZ8QAAAAEqBfIAAAAAAAAAAAHQIZnxAAAAQFvNjqWFObuWxlRLoXhrnOhX9HHR9zsu0oFu5iYMapmCKpB4lIHjQcdeZwfTnA2bMONGlSK4wZvhAi41ULOdtQI=	SvMIAR6SoMk0W6k2SEW+HH8Cey0kv58WzUk6zYFBK08AAAAAAAAACgAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAA==	AAAAAgAAAAEAAAAAAAAAAIZb61S09XXjbOdspMqhCVmGHms0lNxBfx0nCAnQIZnxAAAAADuayfYAAAACAAAAAQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAABAAAAAQAAAAAZefXjS9xi9pxHQK0oer0FGlRkNAWChjqbuWcCfB62VwAAAAFFVVIAAAAAAIZb61S09XXjbOdspMqhCVmGHms0lNxBfx0nCAnQIZnxAAAAASoF8gB//////////wAAAAEAAAAA
bfbfd34092c15b02abf528b9d3c52066a8cc969ea91256ba468d1e2b89503455	5	1	AAAAABl59eNL3GL2nEdArSh6vQUaVGQ0BYKGOpu5ZwJ8HrZXAAAACgAAAAIAAAADAAAAAAAAAAAAAAABAAAAAAAAAAMAAAABRVVSAAAAAACGW+tUtPV142znbKTKoQlZhh5rNJTcQX8dJwgJ0CGZ8QAAAAFVU0QAAAAAAK2S5kESgaqIvuu26eE80cyRUbZbVVdCrmsIXSvLRKv8AAAAADuaygAAAAABAAAAAQAAAAAAAAAAAAAAAAAAAAF8HrZXAAAAQHG5Nn8eq48LS9sS7PkTIDjREiwID7MfJBEZJSx2P5V73FpxYkG+REJLzEz5jYOsMtSryYiw5GvzIOlgk6jiqQQ=	v7/TQJLBWwKr9Si508UgZqjMlp6pEla6Ro0eK4lQNFUAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAGXn140vcYvacR0CtKHq9BRpUZDQFgoY6m7lnAnwetlcAAAAAAAAAAQAAAAFFVVIAAAAAAIZb61S09XXjbOdspMqhCVmGHms0lNxBfx0nCAnQIZnxAAAAAVVTRAAAAAAArZLmQRKBqoi+67bp4TzRzJFRtltVV0KuawhdK8tEq/wAAAAAO5rKAAAAAAEAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAACAAAAABl59eNL3GL2nEdArSh6vQUaVGQ0BYKGOpu5ZwJ8HrZXAAAAAAAAAAEAAAABRVVSAAAAAACGW+tUtPV142znbKTKoQlZhh5rNJTcQX8dJwgJ0CGZ8QAAAAFVU0QAAAAAAK2S5kESgaqIvuu26eE80cyRUbZbVVdCrmsIXSvLRKv8AAAAADuaygAAAAABAAAAAQAAAAAAAAAAAAAAAQAAAAAAAAAAGXn140vcYvacR0CtKHq9BRpUZDQFgoY6m7lnAnwetlcAAAAAO5rJ4gAAAAIAAAADAAAAAwAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA==
1a3859d7e5feea23afe06371c6fc3f4dac92558a7301143660015fc8c19118f7	5	2	AAAAABl59eNL3GL2nEdArSh6vQUaVGQ0BYKGOpu5ZwJ8HrZXAAAACgAAAAIAAAAEAAAAAAAAAAAAAAABAAAAAAAAAAMAAAABRVVSAAAAAACGW+tUtPV142znbKTKoQlZhh5rNJTcQX8dJwgJ0CGZ8QAAAAFVU0QAAAAAAK2S5kESgaqIvuu26eE80cyRUbZbVVdCrmsIXSvLRKv8AAAAAEI6NccAAAAKAAAACQAAAAAAAAAAAAAAAAAAAAF8HrZXAAAAQGA1NgMtKYh6KLPAVbngiFayalFTHR6z7B7zdfIuR+dKysqk8iCxc82LoBPSCUadgOm6QFx3TKDBG/r9j313Fg8=	GjhZ1+X+6iOv4GNxxvw/TaySVYpzARQ2YAFfyMGRGPcAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAGXn140vcYvacR0CtKHq9BRpUZDQFgoY6m7lnAnwetlcAAAAAAAAAAgAAAAFFVVIAAAAAAIZb61S09XXjbOdspMqhCVmGHms0lNxBfx0nCAnQIZnxAAAAAVVTRAAAAAAArZLmQRKBqoi+67bp4TzRzJFRtltVV0KuawhdK8tEq/wAAAAAQjo1xwAAAAoAAAAJAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAACAAAAABl59eNL3GL2nEdArSh6vQUaVGQ0BYKGOpu5ZwJ8HrZXAAAAAAAAAAIAAAABRVVSAAAAAACGW+tUtPV142znbKTKoQlZhh5rNJTcQX8dJwgJ0CGZ8QAAAAFVU0QAAAAAAK2S5kESgaqIvuu26eE80cyRUbZbVVdCrmsIXSvLRKv8AAAAAEI6NccAAAAKAAAACQAAAAAAAAAAAAAAAQAAAAAAAAAAGXn140vcYvacR0CtKHq9BRpUZDQFgoY6m7lnAnwetlcAAAAAO5rJ2AAAAAIAAAAEAAAABAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA==
72a8fd22e864cd6a9934d5fd758312ea18d28ac6f6d45289d615ae45e8671dc5	5	3	AAAAABl59eNL3GL2nEdArSh6vQUaVGQ0BYKGOpu5ZwJ8HrZXAAAACgAAAAIAAAAFAAAAAAAAAAAAAAABAAAAAAAAAAMAAAABRVVSAAAAAACGW+tUtPV142znbKTKoQlZhh5rNJTcQX8dJwgJ0CGZ8QAAAAFVU0QAAAAAAK2S5kESgaqIvuu26eE80cyRUbZbVVdCrmsIXSvLRKv8AAAAAEqBfIAAAAAFAAAABAAAAAAAAAAAAAAAAAAAAAF8HrZXAAAAQLs/Z/3zRTdYbsY5HFGHUa2DbALiDGaAc+BJK1h0yasZpqNNGdauuw9/l5NA1tv3C9FNB7LbCAEw7q68u+TSBAM=	cqj9IuhkzWqZNNX9dYMS6hjSisb21FKJ1hWuRehnHcUAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAGXn140vcYvacR0CtKHq9BRpUZDQFgoY6m7lnAnwetlcAAAAAAAAAAwAAAAFFVVIAAAAAAIZb61S09XXjbOdspMqhCVmGHms0lNxBfx0nCAnQIZnxAAAAAVVTRAAAAAAArZLmQRKBqoi+67bp4TzRzJFRtltVV0KuawhdK8tEq/wAAAAASoF8gAAAAAUAAAAEAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAACAAAAABl59eNL3GL2nEdArSh6vQUaVGQ0BYKGOpu5ZwJ8HrZXAAAAAAAAAAMAAAABRVVSAAAAAACGW+tUtPV142znbKTKoQlZhh5rNJTcQX8dJwgJ0CGZ8QAAAAFVU0QAAAAAAK2S5kESgaqIvuu26eE80cyRUbZbVVdCrmsIXSvLRKv8AAAAAEqBfIAAAAAFAAAABAAAAAAAAAAAAAAAAQAAAAAAAAAAGXn140vcYvacR0CtKHq9BRpUZDQFgoY6m7lnAnwetlcAAAAAO5rJzgAAAAIAAAAFAAAABQAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA==
bade0461ec4356acf5db0b010c8260f8595470e2c76a28d1fa0b8c7296ef7be2	6	1	AAAAANJbiHOmDVcPXHd7T4OXMoGAXWjTwZMnc2ADnn2y/niLAAAACgAAAAIAAAADAAAAAAAAAAAAAAABAAAAAAAAAAMAAAABVVNEAAAAAACtkuZBEoGqiL7rtunhPNHMkVG2W1VXQq5rCF0ry0Sr/AAAAAFFVVIAAAAAAIZb61S09XXjbOdspMqhCVmGHms0lNxBfx0nCAnQIZnxAAAAAB3NZQAAAAABAAAAAQAAAAAAAAAAAAAAAAAAAAGy/niLAAAAQOhYL9yTy6Xbrlu6pfHdAjx7cgfeDhvBRagyLqwRxJicnisF4jCQXianALsdOsGszQxOWb4sUbV4DVbv/4kJAQY=	ut4EYexDVqz12wsBDIJg+FlUcOLHaijR+guMcpbve+IAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAQAAAAAZefXjS9xi9pxHQK0oer0FGlRkNAWChjqbuWcCfB62VwAAAAAAAAABAAAAAUVVUgAAAAAAhlvrVLT1deNs52ykyqEJWYYeazSU3EF/HScICdAhmfEAAAAAHc1lAAAAAAFVU0QAAAAAAK2S5kESgaqIvuu26eE80cyRUbZbVVdCrmsIXSvLRKv8AAAAAB3NZQAAAAACAAAAAA==	AAAABgAAAAEAAAAAAAAAANJbiHOmDVcPXHd7T4OXMoGAXWjTwZMnc2ADnn2y/niLAAAAADuayeIAAAACAAAAAwAAAAIAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAABAAAAAQAAAAAZefXjS9xi9pxHQK0oer0FGlRkNAWChjqbuWcCfB62VwAAAAFFVVIAAAAAAIZb61S09XXjbOdspMqhCVmGHms0lNxBfx0nCAnQIZnxAAAAAQw4jQB//////////wAAAAEAAAAAAAAAAQAAAAEAAAAAGXn140vcYvacR0CtKHq9BRpUZDQFgoY6m7lnAnwetlcAAAABVVNEAAAAAACtkuZBEoGqiL7rtunhPNHMkVG2W1VXQq5rCF0ry0Sr/AAAAAAdzWUAf/////////8AAAABAAAAAAAAAAEAAAABAAAAANJbiHOmDVcPXHd7T4OXMoGAXWjTwZMnc2ADnn2y/niLAAAAAUVVUgAAAAAAhlvrVLT1deNs52ykyqEJWYYeazSU3EF/HScICdAhmfEAAAAAHc1lAH//////////AAAAAQAAAAAAAAABAAAAAQAAAADSW4hzpg1XD1x3e0+DlzKBgF1o08GTJ3NgA559sv54iwAAAAFVU0QAAAAAAK2S5kESgaqIvuu26eE80cyRUbZbVVdCrmsIXSvLRKv8AAAAAQw4jQB//////////wAAAAEAAAAAAAAAAQAAAAIAAAAAGXn140vcYvacR0CtKHq9BRpUZDQFgoY6m7lnAnwetlcAAAAAAAAAAQAAAAFFVVIAAAAAAIZb61S09XXjbOdspMqhCVmGHms0lNxBfx0nCAnQIZnxAAAAAVVTRAAAAAAArZLmQRKBqoi+67bp4TzRzJFRtltVV0KuawhdK8tEq/wAAAAAHc1lAAAAAAEAAAABAAAAAAAAAAA=
a1b554358f63aea0f114700376a2eea187517aba948b990651948bcfff8fe7e5	6	2	AAAAANJbiHOmDVcPXHd7T4OXMoGAXWjTwZMnc2ADnn2y/niLAAAACgAAAAIAAAAEAAAAAAAAAAAAAAABAAAAAAAAAAMAAAABVVNEAAAAAACtkuZBEoGqiL7rtunhPNHMkVG2W1VXQq5rCF0ry0Sr/AAAAAAAAAAAHc1lAAAAAAEAAAABAAAAAAAAAAAAAAAAAAAAAbL+eIsAAABAbr6L+zJlNnXW4js8l6I0xHhs3nxHKFYmdn/nV+/WaD+rtSxPv2E518YfBzR4/w+AW963zkDb/ZQd8bUqQAHhDg==	obVUNY9jrqDxFHADdqLuoYdRerqUi5kGUZSLz/+P5+UAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAA0luIc6YNVw9cd3tPg5cygYBdaNPBkydzYAOefbL+eIsAAAAAAAAABAAAAAFVU0QAAAAAAK2S5kESgaqIvuu26eE80cyRUbZbVVdCrmsIXSvLRKv8AAAAAAAAAAAdzWUAAAAAAQAAAAEAAAAAAAAAAAAAAAA=	AAAAAgAAAAAAAAACAAAAANJbiHOmDVcPXHd7T4OXMoGAXWjTwZMnc2ADnn2y/niLAAAAAAAAAAQAAAABVVNEAAAAAACtkuZBEoGqiL7rtunhPNHMkVG2W1VXQq5rCF0ry0Sr/AAAAAAAAAAAHc1lAAAAAAEAAAABAAAAAAAAAAAAAAABAAAAAAAAAADSW4hzpg1XD1x3e0+DlzKBgF1o08GTJ3NgA559sv54iwAAAAA7msnYAAAAAgAAAAQAAAADAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
\.


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (accountid);


--
-- Name: ledgerheaders_ledgerseq_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ledgerheaders
    ADD CONSTRAINT ledgerheaders_ledgerseq_key UNIQUE (ledgerseq);


--
-- Name: ledgerheaders_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY ledgerheaders
    ADD CONSTRAINT ledgerheaders_pkey PRIMARY KEY (ledgerhash);


--
-- Name: offers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY offers
    ADD CONSTRAINT offers_pkey PRIMARY KEY (offerid);


--
-- Name: peers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY peers
    ADD CONSTRAINT peers_pkey PRIMARY KEY (ip, port);


--
-- Name: signers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY signers
    ADD CONSTRAINT signers_pkey PRIMARY KEY (accountid, publickey);


--
-- Name: storestate_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY storestate
    ADD CONSTRAINT storestate_pkey PRIMARY KEY (statename);


--
-- Name: trustlines_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trustlines
    ADD CONSTRAINT trustlines_pkey PRIMARY KEY (accountid, issuer, alphanumcurrency);


--
-- Name: txhistory_ledgerseq_txindex_key; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY txhistory
    ADD CONSTRAINT txhistory_ledgerseq_txindex_key UNIQUE (ledgerseq, txindex);


--
-- Name: txhistory_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY txhistory
    ADD CONSTRAINT txhistory_pkey PRIMARY KEY (txid, ledgerseq);


--
-- Name: accountbalances; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX accountbalances ON accounts USING btree (balance);


--
-- Name: accountlines; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX accountlines ON trustlines USING btree (accountid);


--
-- Name: getsissuerindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX getsissuerindex ON offers USING btree (getsissuer);


--
-- Name: ledgersbyseq; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX ledgersbyseq ON ledgerheaders USING btree (ledgerseq);


--
-- Name: paysissuerindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX paysissuerindex ON offers USING btree (paysissuer);


--
-- Name: priceindex; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX priceindex ON offers USING btree (price);


--
-- Name: signersaccount; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX signersaccount ON signers USING btree (accountid);


--
-- PostgreSQL database dump complete
--

