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
gspbxqXqEUZkiCCEFFCN9Vu4FLucdjLLdLcsV6E82Qc1T7ehsTC	99999969999999970	3	0	\N		01000000	0
gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	9999999960	8589934596	0	\N		01000000	0
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	9999999920	8589934600	8	\N		01000000	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	9999999920	8589934600	8	\N		01000000	0
\.


--
-- Data for Name: ledgerheaders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY ledgerheaders (ledgerhash, prevhash, bucketlisthash, ledgerseq, closetime, data) FROM stdin;
e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	0000000000000000000000000000000000000000000000000000000000000000	366ab1da319554c51293d7cbf7893a2373dbb0adb73bc8f86d4842995a948be6	1	0	AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA2arHaMZVUxRKT18v3iTojc9uwrbc7yPhtSEKZWpSL5gAAAAEBY0V4XYoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
89605b6be9fbc8374a51958b4bf7ddc9a3a1fea6823e18bccb91d730fe97955b	e8e10918f9c000c73119abe54cf089f59f9015cc93c49ccf00b5e8b9afb6e6b1	90885bdb22cf2573b2e1c18ca20b1a12182bebdcc66a899ce9a61c3dece31da6	2	1436543375	AAAAAejhCRj5wADHMRmr5UzwifWfkBXMk8SczwC16LmvtuaxD96XGunVj9MERAgW2GAD1+Q6GCg25XT1eorpxPlLZ9gAAAAAVZ/pjwAAAAEAAAAIAAAAAQAAAAEAAAAAZR/V/XSlGMIypJnXdAxBVVtRHMdBEjilT4w3+R1ZRtOQiFvbIs8lc7LhwYyiCxoSGCvr3MZqiZzpphw97OMdpgAAAAIBY0V4XYoAAAAAAAAAAAAeAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
cc0a344fc1033efa3426a23a1d08d8e0d42251197db20b41945c804b4a0c2f83	89605b6be9fbc8374a51958b4bf7ddc9a3a1fea6823e18bccb91d730fe97955b	f876f3a5c550e829b0366bfe1d8f80e5ef496b453fd06bd5b9fe2373acf57773	3	1436543376	AAAAAYlgW2vp+8g3SlGVi0v33cmjof6mgj4YvMuR1zD+l5VbWKyVMhXNqd6PDrRIrJ1jjCa9eBrZuxy7Na6Aa/uCcq8AAAAAVZ/pkAAAAAAAAAAAT+BND0fXGDSorlGwr9agzMemOjRzD6eT9yFTc8ktfxj4dvOlxVDoKbA2a/4dj4Dl70lrRT/Qa9W5/iNzrPV3cwAAAAMBY0V4XYoAAAAAAAAAAABGAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
2dc2c88f0d93d121a5f30e08315c552c9c700180b7a659eb34d8caf06afe35c3	cc0a344fc1033efa3426a23a1d08d8e0d42251197db20b41945c804b4a0c2f83	d69195f5a7f8d404f3f24d423fa220a47462b68c8d702e2084dd9f43cb007174	4	1436543377	AAAAAcwKNE/BAz76NCaiOh0I2ODUIlEZfbILQZRcgEtKDC+DvxNmenyeIdhjPlEKaKdQB+ZU1GHh1mn/z+sKOxpcCjYAAAAAVZ/pkQAAAAAAAAAAe6OQWcBBE+2lqbtCj+rK2/uGR88CvEzUQCTmRuTKxQrWkZX1p/jUBPPyTUI/oiCkdGK2jI1wLiCE3Z9DywBxdAAAAAQBY0V4XYoAAAAAAAAAAABuAAAAAAAAAAAAAAAAAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
6e67e96cba8a9388a7645eb273cc9d8b253a93bdd6d7d2f6804e1e1f518a7219	2dc2c88f0d93d121a5f30e08315c552c9c700180b7a659eb34d8caf06afe35c3	c0a87e2377563e50808ea021ac97333076323fadcfb8b278dda505542cf21700	5	1436543378	AAAAAS3CyI8Nk9EhpfMOCDFcVSyccAGAt6ZZ6zTYyvBq/jXDZ3+CPg2j7UHXFv43TEsZA7mveCVwSxhA6sQdEG4UDDQAAAAAVZ/pkgAAAAAAAAAAJZg0KiUCmucBl4UEKfR6vgxrhqnp8Ex3ASyQaxwT+K7AqH4jd1Y+UICOoCGslzMwdjI/rc+4snjdpQVULPIXAAAAAAUBY0V4XYoAAAAAAAAAAACqAAAAAAAAAAAAAAAGAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
261cc3dd6651d057e1756fb9acb420e895fe1cf87e654b6f5906d12a5ab55eeb	6e67e96cba8a9388a7645eb273cc9d8b253a93bdd6d7d2f6804e1e1f518a7219	610a0a9196f3c259cb93870041a0e237a9a996c8e6adc5ed0306862c35d66ad7	6	1436543379	AAAAAW5n6Wy6ipOIp2ResnPMnYslOpO91tfS9oBOHh9RinIZjq/mXayCG9HqpihjdtEonwJGoQoGSh2BhOC9AVP77qIAAAAAVZ/pkwAAAAAAAAAA61vkK/KdhnX67MT82tUzmZZs0p8+GwYRojv+hQyOOhxhCgqRlvPCWcuThwBBoOI3qamWyOatxe0DBoYsNdZq1wAAAAYBY0V4XYoAAAAAAAAAAADmAAAAAAAAAAAAAAAMAAAACgCYloAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
\.


--
-- Data for Name: offers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY offers (accountid, offerid, paysalphanumcurrency, paysissuer, getsalphanumcurrency, getsissuer, amount, pricen, priced, price, flags) FROM stdin;
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	1	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	\N	\N	1	1	10	1000000	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	2	\N	\N	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	10	15	1	150000000	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	3	\N	\N	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	100	20	1	200000000	0
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	4	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	\N	\N	11	1	9	1111111	0
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	5	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	\N	\N	200	1	5	2000000	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	6	\N	\N	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	1000	50	1	500000000	0
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	7	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	BTC	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	1	1	10	1000000	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	8	BTC	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	10	15	1	150000000	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	9	BTC	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	100	20	1	200000000	0
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	10	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	BTC	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	11	1	9	1111111	0
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	11	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	BTC	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	200	1	5	2000000	0
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	12	BTC	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	USD	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	1000	50	1	500000000	0
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
lastclosedledger                	261cc3dd6651d057e1756fb9acb420e895fe1cf87e654b6f5906d12a5ab55eeb
historyarchivestate             	{\n    "version": 0,\n    "currentLedger": 6,\n    "currentBuckets": [\n        {\n            "curr": "4c7f963dcca7767c678c28eec0a1d2e3d40ec463eae4b3d09bf02222ea7afbdf",\n            "next": {\n                "state": 0\n            },\n            "snap": "5f72ec7af92936eb461487af2538027c07acccabd218e94d0a61bcc3114b8ef7"\n        },\n        {\n            "curr": "7b3bcee8d58ca787ceb7a89bc51f7a9e49871a2bfd7f50bb7ba7ba137a6524a3",\n            "next": {\n                "state": 1,\n                "output": "5f72ec7af92936eb461487af2538027c07acccabd218e94d0a61bcc3114b8ef7"\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        },\n        {\n            "curr": "0000000000000000000000000000000000000000000000000000000000000000",\n            "next": {\n                "state": 0\n            },\n            "snap": "0000000000000000000000000000000000000000000000000000000000000000"\n        }\n    ]\n}
\.


--
-- Data for Name: trustlines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY trustlines (accountid, issuer, alphanumcurrency, tlimit, balance, flags) FROM stdin;
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	USD	9223372036854775807	5000	1
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	USD	9223372036854775807	5000	1
gsKuurNYgtBhTSFfsCaWqNb3Ze5Je9csKTSLfjo8Ko2b1f66ayZ	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	BTC	9223372036854775807	5000	1
gqdUHrgHUp8uMb74HiQvYztze2ffLhVXpPwj7gEZiJRa4jhCXQ	gsPsm67nNK8HtwMedJZFki3jAEKgg1s4nRKrHREFqTzT6ErzBiq	BTC	9223372036854775807	5000	1
\.


--
-- Data for Name: txhistory; Type: TABLE DATA; Schema: public; Owner: -
--

COPY txhistory (txid, ledgerseq, txindex, txbody, txresult, txmeta) FROM stdin;
0427feb565c868311d14311a060fa2623d2127b791a196e4da16272ef15ef3b4	2	1	AAAAAImbKEDtVjbFbdxfFLI5dfefG6I4jSaU5MVuzd3JYOXvAAAACgAAAAAAAAABAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAACVAvkAAAAAAAAAAAByWDl7wAAAEBfVaoY3OPkgbSNNK/7fhhI8jzqOJs8fY67xnZA2ACsWLu1uFCA9VyyyciT+EdGtgRfid7kFw/TKaknht6bzOEK	BCf+tWXIaDEdFDEaBg+iYj0hJ7eRoZbk2hYnLvFe87QAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAgAAAAAAAAAAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAlQL5AAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAABAAAAAAAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXYJfhv2AAAAAAAAAAEAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
afd2cddc8c3234e5d38fe12dc368dbe873531d18da9a7bdf2e3682f604a1335c	2	2	AAAAAImbKEDtVjbFbdxfFLI5dfefG6I4jSaU5MVuzd3JYOXvAAAACgAAAAAAAAACAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAACVAvkAAAAAAAAAAAByWDl7wAAAEAsQ29KSJJ3ShKgVO75wu7uYUs03DapcxxIYk7qZv+A+4zP4kHMv70aLVUtXGwnWQ7QJK9CEYsb7jP3CPqmMS0D	r9LN3IwyNOXTj+Etw2jb6HNTHRjamnvfLjaC9gShM1wAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAgAAAAAAAAAAAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAlQL5AAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAABAAAAAAAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXO1cjfsAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
c28e0249823bea5032278533cdc589047c3b810acb7cc5062b6cf871d9c621f2	2	3	AAAAAImbKEDtVjbFbdxfFLI5dfefG6I4jSaU5MVuzd3JYOXvAAAACgAAAAAAAAADAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAACVAvkAAAAAAAAAAAByWDl7wAAAEDmAThQU+EV1c9bJh4iayUlrl4snFPf8UUdRObHPZxIG5jcFp3EKOQNZZIs9RVdxnstp8ZnS59eAj7SitKAbsEN	wo4CSYI76lAyJ4UzzcWJBHw7gQrLfMUGK2z4cdnGIfIAAAAAAAAACgAAAAAAAAABAAAAAAAAAAAAAAAAAAAAAA==	AAAAAgAAAAAAAAAAAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAlQL5AAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAABAAAAAAAAAACJmyhA7VY2xW3cXxSyOXX3nxuiOI0mlOTFbs3dyWDl7wFjRXFhZlPiAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
7ade60aaf8cae0e43d615389eddcf8ccb35c0a2cc80916f3153431af728dda4b	3	1	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt73//////////AAAAAAAAAAGu5L5MAAAAQBNNf5QVwgCyQ6ApWHwbYIv5F3TG676ur37yue2kTY8pojx9X0T6LzGntDy6npPyrL7rtvYm3jTdHMLRrYG9awI=	et5gqvjK4OQ9YVOJ7dz4zLNcCizICRbzFTQxr3KN2ksAAAAAAAAACgAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==	AAAAAgAAAAAAAAABAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAH//////////AAAAAQAAAAAAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+P2AAAAAgAAAAEAAAABAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
df4c6ac90b1676dbd14700ce39baac52c8d9a0cac8b084b845e4ad1ec7f2c061	3	2	AAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAACgAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt73//////////AAAAAAAAAAFvFIhaAAAAQHY8b1kz0Jac+HvyPDvSIh1YgZ98ujV9QhcDT5IGnCkSxpSitLayuYAuv3hGT14NzT2apINyd80WICYOnDJE1AM=	30xqyQsWdtvRRwDOObqsUsjZoMrIsIS4ReStHsfywGEAAAAAAAAACgAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==	AAAAAgAAAAAAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAH//////////AAAAAQAAAAAAAAABAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAJUC+P2AAAAAgAAAAEAAAABAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
80422c70a1ca53c62e0cd5b6d79591024940870eb263f21e32f5b382d16b556c	3	3	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAACAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABQlRDAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt73//////////AAAAAAAAAAGu5L5MAAAAQDCHNU46u916bx4/TQYocdltjFUmeqzYdqE0jsSEKFGGbNnnWsEqp7zjy+fembaLmYncMf/xUsZPM3CX8/gXGAE=	gEIscKHKU8YuDNW215WRAklAhw6yY/IeMvWzgtFrVWwAAAAAAAAACgAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==	AAAAAgAAAAAAAAABAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAUJUQwAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAH//////////AAAAAQAAAAAAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+PsAAAAAgAAAAIAAAACAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
7200e84eb7e7b636e2cdb2585036bf5b9f545e9d39426c34eb3224d7a6964aa9	3	4	AAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAACgAAAAIAAAACAAAAAAAAAAAAAAABAAAAAAAAAAYAAAABQlRDAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt73//////////AAAAAAAAAAFvFIhaAAAAQAKMf7HydfY6iRMirw1qgwFidUWzqt5GtQeZ0zeXSk464QuG8QQD/74nGsiYXNPxz1pCgDDAR7Y2m2UTKDusyQI=	cgDoTrfntjbizbJYUDa/W59UXp05Qmw06zIk16aWSqkAAAAAAAAACgAAAAAAAAABAAAAAAAAAAYAAAAAAAAAAA==	AAAAAgAAAAAAAAABAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAUJUQwAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAH//////////AAAAAQAAAAAAAAABAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAJUC+PsAAAAAgAAAAIAAAACAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
192fb1919a67b63fac88c9e4db9923b1810b3442487a0712bf1197ea36672c24	4	1	AAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAACgAAAAIAAAABAAAAAAAAAAAAAAABAAAAAAAAAAEAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAABOIAAAAAAAAAAH5kC3vAAAAQPI1aSrzkR0SS/nqcU/XgkYDUDQKilPhQMa9ZLiVftj0AeUOv1FE9uwKDqxdP7oAtqZ/4kMD/HXQH5yRA2QKwQM=	GS+xkZpntj+siMnk25kjsYELNEJIegcSvxGX6jZnLCQAAAAAAAAACgAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAA==	AAAAAgAAAAEAAAAAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAlQL4/YAAAACAAAAAQAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAABAAAAAQAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAE4h//////////wAAAAEAAAAA
b28c0d0e6fc933792faa0a4f70633b93d88b969c0407cd99f3881ef781541f97	4	2	AAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAACgAAAAIAAAACAAAAAAAAAAAAAAABAAAAAAAAAAEAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAABOIAAAAAAAAAAH5kC3vAAAAQMoaORJvJQSagZZWqDIHQfDXsWh8y1TG5KSb/C5skqsgC3dY1Qiscyj/nN0vGtjCY4sBkDkf7fOYqxEo/axwBQU=	sowNDm/JM3kvqgpPcGM7k9iLlpwEB82Z84ge94FUH5cAAAAAAAAACgAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAA==	AAAAAgAAAAEAAAAAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAlQL4+wAAAACAAAAAgAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAABAAAAAQAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAE4h//////////wAAAAEAAAAA
7bebd9e8debab8bf95f560f9f45e49708f56aa2ec9950e0d808ffd1431b59d6e	4	3	AAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAACgAAAAIAAAADAAAAAAAAAAAAAAABAAAAAAAAAAEAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAABQlRDAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAABOIAAAAAAAAAAH5kC3vAAAAQJS8MaCzR24obmIwPvXOgCwPi+k9Ln7MQLl/bndEAaRuC6xe/vnzx6K5rYe82WCKhf4aGxsMW31/LaEpsEjW3gQ=	e+vZ6N66uL+V9WD59F5JcI9Wqi7JlQ4NgI/9FDG1nW4AAAAAAAAACgAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAA==	AAAAAgAAAAEAAAAAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAlQL4+IAAAACAAAAAwAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAABAAAAAQAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAFCVEMAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAE4h//////////wAAAAEAAAAA
8338f1d185000f089f5504c512399e7d9828cf1aae9c37ef2ef7cb7fbad10814	4	4	AAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAACgAAAAIAAAAEAAAAAAAAAAAAAAABAAAAAAAAAAEAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAABQlRDAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAABOIAAAAAAAAAAH5kC3vAAAAQBP8wHHYap/05mQFlYyN4hK3yQRrj4eqq906IacX+rrgSeoNmVT5dnvKKzXNoPAR4tB39cO4sIf5+Kk2E0OWIA4=	gzjx0YUADwifVQTFEjmefZgozxqunDfvLvfLf7rRCBQAAAAAAAAACgAAAAAAAAABAAAAAAAAAAEAAAAAAAAAAA==	AAAAAgAAAAEAAAAAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAlQL49gAAAACAAAABAAAAAAAAAAAAAAAAAAAAAABAAAAAAAAAAAAAAAAAAABAAAAAQAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAFCVEMAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAE4h//////////wAAAAEAAAAA
d2c7a0d6256324229256592acaa51477b3b13f3ebfaa0bca1fbeb2187f88fb37	5	1	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAADAAAAAAAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAQAAAAEAAAAKAAAAAAAAAAAAAAAAAAAAAa7kvkwAAABAB6ozARjZnHhNfjk2aZMGSHM5OeprF3Odkc1cZ1zP+1CI9sRnhjtt/TIY55pO0R4cOgG/GF9bx5SdVKhF2PAWBQ==	0seg1iVjJCKSVlkqyqUUd7OxPz6/qgvKH76yGH+I+zcAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAAAAAAQAAAAAAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAAAABAAAAAQAAAAoAAAAAAAAAAAAAAAA=	AAAAAgAAAAAAAAACAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAAAAAAEAAAAAAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAQAAAAEAAAAKAAAAAAAAAAAAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+PiAAAAAgAAAAMAAAADAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
c0c1f53206f39477f038f2fae3ea590d08f38a9f12434dfefce2e28a45a50cc5	5	2	AAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAACgAAAAIAAAADAAAAAAAAAAAAAAABAAAAAAAAAAMAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAAAAAAAAACgAAAA8AAAABAAAAAAAAAAAAAAAAAAAAAW8UiFoAAABA8778xD4fKzF0brvPzDQbdZ8xd7JwN6D1IdCIvsJ4GbYb1VpPPh7UQfy6T1u/4oYsMah4yMbwo9CkcKa4JuOzDg==	wMH1MgbzlHfwOPL64+pZDQjzip8SQ03+/OLiikWlDMUAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAAAAAAgAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAAAAAAKAAAADwAAAAEAAAAAAAAAAAAAAAA=	AAAAAgAAAAAAAAACAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAAAAAAIAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAAAAAAAAACgAAAA8AAAABAAAAAAAAAAAAAAABAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAJUC+PiAAAAAgAAAAMAAAADAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
b77efd903953ad583f647df4f78b2facc0799f68aa74f716dceb8b3b7f46dbb9	5	3	AAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAACgAAAAIAAAAEAAAAAAAAAAAAAAABAAAAAAAAAAMAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAAAAAAAAAZAAAABQAAAABAAAAAAAAAAAAAAAAAAAAAW8UiFoAAABAdpIXozCGL713eZ8qI7tA5/ePDoDez2zc9eUQutW+9nN91VD+la4xuky2VdLPgrVcMOEOm4QU5hSPNcCSS/1kBw==	t379kDlTrVg/ZH3094svrMB5n2iqdPcW3OuLO39G27kAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAAAAAAwAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAAAAABkAAAAFAAAAAEAAAAAAAAAAAAAAAA=	AAAAAgAAAAAAAAACAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAAAAAAMAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAAAAAAAAAZAAAABQAAAABAAAAAAAAAAAAAAABAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAJUC+PYAAAAAgAAAAQAAAAEAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
8096977736bb9a9b09bc6116056e035c785105096481f8272e9b22bc40446b06	5	4	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAAEAAAAAAAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAACwAAAAEAAAAJAAAAAAAAAAAAAAAAAAAAAa7kvkwAAABAkLDJefvdo5G/rRuJUOsl32MpMUQGIPN/c+PZGuLAj3Bi27HJiu7yfH7EChgL28T7jxMc3Fs1r0rZvbHUgD+gDg==	gJaXdza7mpsJvGEWBW4DXHhRBQlkgfgnLpsivEBEawYAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAAAAABAAAAAAAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAAAALAAAAAQAAAAkAAAAAAAAAAAAAAAA=	AAAAAgAAAAAAAAACAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAAAAAAQAAAAAAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAACwAAAAEAAAAJAAAAAAAAAAAAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+PYAAAAAgAAAAQAAAAEAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
20ece43bb6e22da1b2ccca57d0d38d059090f75b3451a0726071ae063e7a0612	5	5	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAAFAAAAAAAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAyAAAAAEAAAAFAAAAAAAAAAAAAAAAAAAAAa7kvkwAAABAQOsJeuJtqmAiie6AgVGMpNiCR5tAhYUD2WQ3GG3RagNfYMSCiB+x1c8U+o4iZin13KL/shdbVmD1FbyjM9S2Ag==	IOzkO7biLaGyzMpX0NONBZCQ91s0UaByYHGuBj56BhIAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAAAAABQAAAAAAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAAADIAAAAAQAAAAUAAAAAAAAAAAAAAAA=	AAAAAgAAAAAAAAACAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAAAAAAUAAAAAAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAyAAAAAEAAAAFAAAAAAAAAAAAAAABAAAAAAAAAACuo3ot45qCPExpQ/3oHN+z17Ryis1lfMFYmQWgruS+TAAAAAJUC+POAAAAAgAAAAUAAAAFAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
75f593013675be97938d2fe2e4c1d0629d873fee62f5a4836955deb596940848	5	6	AAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAACgAAAAIAAAAFAAAAAAAAAAAAAAABAAAAAAAAAAMAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAAAAAAAAD6AAAADIAAAABAAAAAAAAAAAAAAAAAAAAAW8UiFoAAABACph4g/pZjox1Mg9AqPF6C4HDJlaBLVq+5pMMj/l7siEl4Q06YR1WEsQdPOQnBDUN6riv/uvSEk/f4+0OfGjLBw==	dfWTATZ1vpeTjS/i5MHQYp2HP+5i9aSDaVXetZaUCEgAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAAAAABgAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAAAAAPoAAAAMgAAAAEAAAAAAAAAAAAAAAA=	AAAAAgAAAAAAAAACAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAAAAAAYAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAAAAAAAAAAD6AAAADIAAAABAAAAAAAAAAAAAAABAAAAAAAAAABuaCbVXZ2DlXWarV6UxwbW3GNJgpn3ASChIFp5bxSIWgAAAAJUC+POAAAAAgAAAAUAAAAFAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAA
5e49320e88671aed48b98703e7a970a0325db564605337784c3a9bbf64863880	6	1	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAAGAAAAAAAAAAAAAAABAAAAAAAAAAMAAAABQlRDAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAEAAAABAAAACgAAAAAAAAAAAAAAAAAAAAGu5L5MAAAAQH/SCJ6XmryCz1V8locL6SFaMz6j50Oeof27J7nwdlgF8s5/UQrNYmx84jxdrGmxZQ06w6pm8L4GKzkG69aDaQ8=	XkkyDohnGu1IuYcD56lwoDJdtWRgUzd4TDqbv2SGOIAAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAAAAABwAAAAFCVEMAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAAQAAAAEAAAAKAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAACAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAAAAAAcAAAABQlRDAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAEAAAABAAAACgAAAAAAAAAAAAAAAQAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAACVAvjxAAAAAIAAAAGAAAABgAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA==
b366b9cc08150970e1490241bacd4770492357860ead5d320b77e332292be3b7	6	2	AAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAACgAAAAIAAAAGAAAAAAAAAAAAAAABAAAAAAAAAAMAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAFCVEMAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAoAAAAPAAAAAQAAAAAAAAAAAAAAAAAAAAFvFIhaAAAAQJdJHCJ26A9zM5KtHxkXBN/gFO0Q8HxRWkpi0SGjQnh0qb0NXLc8VVUTFGzFhEDhO8oZIWAr54iSCwxtF9QqMQI=	s2a5zAgVCXDhSQJBus1HcEkjV4YOrV0yC3fjMikr47cAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAAAAACAAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAUJUQwAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAACgAAAA8AAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAACAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAAAAAAgAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAFCVEMAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAoAAAAPAAAAAQAAAAAAAAAAAAAAAQAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAACVAvjxAAAAAIAAAAGAAAABgAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA==
aa79ebd5fe9148a654021dfc4358cabee455f9f675943f84a96b24526e78ee6a	6	3	AAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAACgAAAAIAAAAHAAAAAAAAAAAAAAABAAAAAAAAAAMAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAFCVEMAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAGQAAAAUAAAAAQAAAAAAAAAAAAAAAAAAAAFvFIhaAAAAQIwrarAWkj8Y9Ndk1vNuE9BuF3Lpfo9MYynnyox8m9YEF3D6OEOH3fiTUA1rZhLXBM/tOQXg+HJgdzBysYF3PQA=	qnnr1f6RSKZUAh38Q1jKvuRV+fZ1lD+EqWskUm547moAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAAAAACQAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAUJUQwAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAZAAAABQAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAACAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAAAAAAkAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAFCVEMAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAGQAAAAUAAAAAQAAAAAAAAAAAAAAAQAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAACVAvjugAAAAIAAAAHAAAABwAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA==
f813a8dd57d30358b5bf9c5ef3af6f0f0052f660c14a96474c91acb7435b9e7d	6	4	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAAHAAAAAAAAAAAAAAABAAAAAAAAAAMAAAABQlRDAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAsAAAABAAAACQAAAAAAAAAAAAAAAAAAAAGu5L5MAAAAQOprYOvZswajW8y4H0GUhBNjoleVT80EQYZR8yamrgRpco6Hh3ZDYqSY6WliA24p2NWpzAoCMV6QuDSzumzoEQM=	+BOo3VfTA1i1v5xe869vDwBS9mDBSpZHTJGst0Nbnn0AAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAAAAACgAAAAFCVEMAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAACwAAAAEAAAAJAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAACAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAAAAAAoAAAABQlRDAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAAsAAAABAAAACQAAAAAAAAAAAAAAAQAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAACVAvjugAAAAIAAAAHAAAABwAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA==
0e0551f3dc873db0d88ea60fcb44aabca45a6a213164e16d35a0af6f40e3e095	6	5	AAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAACgAAAAIAAAAIAAAAAAAAAAAAAAABAAAAAAAAAAMAAAABQlRDAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAMgAAAABAAAABQAAAAAAAAAAAAAAAAAAAAGu5L5MAAAAQNUEkqLsVC/4gmAzwpE5YGFtm07M3dzYctsCvMYkemB5qQXOuG5AXhGy4I+2VFySqfQu+fT9LUg7WojkS31xiwM=	DgVR89yHPbDYjqYPy0SqvKRaaiExZOFtNaCvb0Dj4JUAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAAAAAAACwAAAAFCVEMAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAVVTRAAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAAyAAAAAEAAAAFAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAACAAAAAK6jei3jmoI8TGlD/egc37PXtHKKzWV8wViZBaCu5L5MAAAAAAAAAAsAAAABQlRDAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAAMgAAAABAAAABQAAAAAAAAAAAAAAAQAAAAAAAAAArqN6LeOagjxMaUP96Bzfs9e0corNZXzBWJkFoK7kvkwAAAACVAvjsAAAAAIAAAAIAAAACAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA==
0238eec8a7a195b41ed886e903a93a8a46ea6777b26bb600086c8b80a42da9d5	6	6	AAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAACgAAAAIAAAAIAAAAAAAAAAAAAAABAAAAAAAAAAMAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAFCVEMAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAA+gAAAAyAAAAAQAAAAAAAAAAAAAAAAAAAAFvFIhaAAAAQC4vlhm4FpdWdbvQFGwYa8twKVdnG0BQxeQiyv9uoxIVGopgYBSY5cRMNHtLOk43gjDceRNSzqfkK+NxXzDMTQk=	AjjuyKehlbQe2IbpA6k6ikbqZ3eya7YACGyLgKQtqdUAAAAAAAAACgAAAAAAAAABAAAAAAAAAAMAAAAAAAAAAAAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAAAAAAADAAAAAFVU0QAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAUJUQwAAAAAAtbgXR6E7oDL0LQ+wYSC9zXvXVT3xiPiYuSb1DvmQLe8AAAAAAAAD6AAAADIAAAABAAAAAAAAAAAAAAAA	AAAAAgAAAAAAAAACAAAAAG5oJtVdnYOVdZqtXpTHBtbcY0mCmfcBIKEgWnlvFIhaAAAAAAAAAAwAAAABVVNEAAAAAAC1uBdHoTugMvQtD7BhIL3Ne9dVPfGI+Ji5JvUO+ZAt7wAAAAFCVEMAAAAAALW4F0ehO6Ay9C0PsGEgvc1711U98Yj4mLkm9Q75kC3vAAAAAAAAA+gAAAAyAAAAAQAAAAAAAAAAAAAAAQAAAAAAAAAAbmgm1V2dg5V1mq1elMcG1txjSYKZ9wEgoSBaeW8UiFoAAAACVAvjsAAAAAIAAAAIAAAACAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAA==
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

