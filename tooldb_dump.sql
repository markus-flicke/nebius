--
-- PostgreSQL database dump
--

\restrict BgqJqWMXzTutnkgdveMpjj5oRk32742ci8PRYkaXAYhO2wDtYlNJ0aYZIrWGlWq

-- Dumped from database version 18.4 (Ubuntu 18.4-0ubuntu0.26.04.1)
-- Dumped by pg_dump version 18.4 (Ubuntu 18.4-0ubuntu0.26.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.runs DROP CONSTRAINT IF EXISTS runs_tool_id_fkey;
DROP INDEX IF EXISTS public.runs_tool_id_idx;
ALTER TABLE IF EXISTS ONLY public.tools DROP CONSTRAINT IF EXISTS tools_pkey;
ALTER TABLE IF EXISTS ONLY public.runs DROP CONSTRAINT IF EXISTS runs_pkey;
ALTER TABLE IF EXISTS public.tools ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.runs ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.tools_id_seq;
DROP TABLE IF EXISTS public.tools;
DROP SEQUENCE IF EXISTS public.runs_id_seq;
DROP TABLE IF EXISTS public.runs;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: runs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.runs (
    id integer NOT NULL,
    tool_id integer NOT NULL,
    user_id text DEFAULT 'anonymous'::text NOT NULL,
    success boolean NOT NULL,
    parameters jsonb DEFAULT '{}'::jsonb NOT NULL,
    result jsonb,
    error text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: runs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.runs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: runs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.runs_id_seq OWNED BY public.runs.id;


--
-- Name: tools; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tools (
    id integer NOT NULL,
    name text NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    inputs jsonb DEFAULT '{}'::jsonb NOT NULL,
    outputs text DEFAULT ''::text NOT NULL,
    conditions text DEFAULT ''::text NOT NULL,
    code text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: tools_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tools_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tools_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tools_id_seq OWNED BY public.tools.id;


--
-- Name: runs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runs ALTER COLUMN id SET DEFAULT nextval('public.runs_id_seq'::regclass);


--
-- Name: tools id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tools ALTER COLUMN id SET DEFAULT nextval('public.tools_id_seq'::regclass);


--
-- Data for Name: runs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.runs (id, tool_id, user_id, success, parameters, result, error, created_at) FROM stdin;
1	1	agent-007	t	{"text": "world"}	{"reversed": "dlrow"}	\N	2026-06-24 15:23:04.642353+02
2	1	markus	t	{"text": "hello"}	{"reversed": "olleh"}	\N	2026-06-24 15:23:04.646374+02
3	1	markus	t	{"text": "hello"}	{"reversed": "olleh"}	\N	2026-06-24 15:23:04.650016+02
4	1	markus	t	{"text": "tool as a service"}	{"reversed": "ecivres a sa loot"}	\N	2026-06-24 15:23:04.653397+02
5	1	anonymous	t	{"text": "tool as a service"}	{"reversed": "ecivres a sa loot"}	\N	2026-06-24 15:23:04.656997+02
6	1	markus	t	{"text": "hello"}	{"reversed": "olleh"}	\N	2026-06-24 15:23:04.66074+02
7	1	markus	t	{"text": "hello"}	{"reversed": "olleh"}	\N	2026-06-24 15:23:04.664489+02
8	1	agent-007	t	{"text": "tool as a service"}	{"reversed": "ecivres a sa loot"}	\N	2026-06-24 15:23:04.668198+02
9	1	agent-007	t	{"text": "hello"}	{"reversed": "olleh"}	\N	2026-06-24 15:23:04.671992+02
10	1	markus	t	{"text": "tool as a service"}	{"reversed": "ecivres a sa loot"}	\N	2026-06-24 15:23:04.675789+02
11	1	agent-007	t	{"text": "world"}	{"reversed": "dlrow"}	\N	2026-06-24 15:23:04.679624+02
12	1	markus	t	{"text": "hello"}	{"reversed": "olleh"}	\N	2026-06-24 15:23:04.683461+02
13	1	anonymous	t	{"text": "hello"}	{"reversed": "olleh"}	\N	2026-06-24 15:23:04.687331+02
14	1	agent-007	t	{"text": "hello"}	{"reversed": "olleh"}	\N	2026-06-24 15:23:04.691125+02
15	1	anonymous	t	{"text": "12345"}	{"reversed": "54321"}	\N	2026-06-24 15:23:04.695144+02
16	1	agent-007	t	{"text": "tool as a service"}	{"reversed": "ecivres a sa loot"}	\N	2026-06-24 15:23:04.698941+02
17	1	markus	t	{"text": "world"}	{"reversed": "dlrow"}	\N	2026-06-24 15:23:04.702724+02
18	1	agent-007	t	{"text": "hello"}	{"reversed": "olleh"}	\N	2026-06-24 15:23:04.70663+02
19	1	markus	t	{"text": "world"}	{"reversed": "dlrow"}	\N	2026-06-24 15:23:04.710741+02
20	1	agent-007	t	{"text": "tool as a service"}	{"reversed": "ecivres a sa loot"}	\N	2026-06-24 15:23:04.714578+02
21	1	markus	t	{"text": "world"}	{"reversed": "dlrow"}	\N	2026-06-24 15:23:04.718444+02
22	1	agent-007	t	{"text": "world"}	{"reversed": "dlrow"}	\N	2026-06-24 15:23:04.722358+02
23	1	markus	t	{"text": "world"}	{"reversed": "dlrow"}	\N	2026-06-24 15:23:04.726235+02
24	1	anonymous	t	{"text": "Nebius"}	{"reversed": "suibeN"}	\N	2026-06-24 15:23:04.730592+02
25	1	agent-007	t	{"text": "tool as a service"}	{"reversed": "ecivres a sa loot"}	\N	2026-06-24 15:23:04.734511+02
26	1	anonymous	t	{"text": "hello"}	{"reversed": "olleh"}	\N	2026-06-24 15:23:04.738453+02
27	1	anonymous	t	{"text": "Nebius"}	{"reversed": "suibeN"}	\N	2026-06-24 15:23:04.74269+02
28	1	agent-007	t	{"text": "Nebius"}	{"reversed": "suibeN"}	\N	2026-06-24 15:23:04.746677+02
29	1	markus	t	{"text": "12345"}	{"reversed": "54321"}	\N	2026-06-24 15:23:04.7509+02
30	1	agent-007	t	{"text": "12345"}	{"reversed": "54321"}	\N	2026-06-24 15:23:04.754904+02
31	1	markus	t	{"text": "world"}	{"reversed": "dlrow"}	\N	2026-06-24 15:23:04.758959+02
32	1	agent-007	t	{"text": "Nebius"}	{"reversed": "suibeN"}	\N	2026-06-24 15:23:04.762989+02
33	1	agent-007	t	{"text": "tool as a service"}	{"reversed": "ecivres a sa loot"}	\N	2026-06-24 15:23:04.766887+02
34	1	agent-007	t	{"text": "tool as a service"}	{"reversed": "ecivres a sa loot"}	\N	2026-06-24 15:23:04.770851+02
35	1	markus	t	{"text": "hello"}	{"reversed": "olleh"}	\N	2026-06-24 15:23:04.775209+02
36	1	agent-007	t	{"text": "world"}	{"reversed": "dlrow"}	\N	2026-06-24 15:23:04.779448+02
37	1	markus	t	{"text": "tool as a service"}	{"reversed": "ecivres a sa loot"}	\N	2026-06-24 15:23:04.783459+02
38	1	markus	t	{"text": "world"}	{"reversed": "dlrow"}	\N	2026-06-24 15:23:04.787432+02
39	1	agent-007	t	{"text": "12345"}	{"reversed": "54321"}	\N	2026-06-24 15:23:04.791481+02
40	1	anonymous	t	{"text": "Nebius"}	{"reversed": "suibeN"}	\N	2026-06-24 15:23:04.79577+02
41	2	anonymous	t	{"name": "Markus"}	{"greeting": "Happy Wednesday, Markus!"}	\N	2026-06-24 15:23:04.803418+02
42	2	markus	t	{"name": "Markus"}	{"greeting": "Happy Wednesday, Markus!"}	\N	2026-06-24 15:23:04.807534+02
43	2	agent-007	t	{"name": "Ada"}	{"greeting": "Happy Wednesday, Ada!"}	\N	2026-06-24 15:23:04.811776+02
44	2	markus	t	{"name": "Linus"}	{"greeting": "Happy Wednesday, Linus!"}	\N	2026-06-24 15:23:04.815769+02
45	2	agent-007	t	{"name": "Ada"}	{"greeting": "Happy Wednesday, Ada!"}	\N	2026-06-24 15:23:04.819702+02
46	2	agent-007	t	{"name": "Markus"}	{"greeting": "Happy Wednesday, Markus!"}	\N	2026-06-24 15:23:04.823662+02
47	2	markus	t	{"name": "Ada"}	{"greeting": "Happy Wednesday, Ada!"}	\N	2026-06-24 15:23:04.827781+02
48	2	agent-007	t	{"name": "Grace"}	{"greeting": "Happy Wednesday, Grace!"}	\N	2026-06-24 15:23:04.831841+02
49	2	agent-007	t	{"name": "Linus"}	{"greeting": "Happy Wednesday, Linus!"}	\N	2026-06-24 15:23:04.83581+02
50	2	agent-007	t	{"name": "Grace"}	{"greeting": "Happy Wednesday, Grace!"}	\N	2026-06-24 15:23:04.839761+02
51	2	anonymous	t	{"name": "Linus"}	{"greeting": "Happy Wednesday, Linus!"}	\N	2026-06-24 15:23:04.843949+02
52	2	markus	t	{"name": "Markus"}	{"greeting": "Happy Wednesday, Markus!"}	\N	2026-06-24 15:23:04.847952+02
53	2	markus	t	{"name": "Grace"}	{"greeting": "Happy Wednesday, Grace!"}	\N	2026-06-24 15:23:04.85195+02
54	2	markus	t	{"name": "Grace"}	{"greeting": "Happy Wednesday, Grace!"}	\N	2026-06-24 15:23:04.855917+02
55	2	agent-007	t	{"name": "Ada"}	{"greeting": "Happy Wednesday, Ada!"}	\N	2026-06-24 15:23:04.860067+02
56	2	anonymous	t	{"name": "Ada"}	{"greeting": "Happy Wednesday, Ada!"}	\N	2026-06-24 15:23:04.864121+02
57	2	anonymous	t	{"name": "Ada"}	{"greeting": "Happy Wednesday, Ada!"}	\N	2026-06-24 15:23:04.86806+02
58	2	markus	t	{"name": "Ada"}	{"greeting": "Happy Wednesday, Ada!"}	\N	2026-06-24 15:23:04.871962+02
59	2	anonymous	t	{"name": "Ada"}	{"greeting": "Happy Wednesday, Ada!"}	\N	2026-06-24 15:23:04.876038+02
60	2	agent-007	t	{"name": "Linus"}	{"greeting": "Happy Wednesday, Linus!"}	\N	2026-06-24 15:23:04.88026+02
61	2	markus	t	{"name": "Ada"}	{"greeting": "Happy Wednesday, Ada!"}	\N	2026-06-24 15:23:04.884327+02
62	2	agent-007	t	{"name": "Grace"}	{"greeting": "Happy Wednesday, Grace!"}	\N	2026-06-24 15:23:04.888374+02
63	2	agent-007	t	{"name": "Linus"}	{"greeting": "Happy Wednesday, Linus!"}	\N	2026-06-24 15:23:04.892801+02
64	2	markus	t	{"name": "Linus"}	{"greeting": "Happy Wednesday, Linus!"}	\N	2026-06-24 15:23:04.897002+02
65	2	anonymous	t	{"name": "Grace"}	{"greeting": "Happy Wednesday, Grace!"}	\N	2026-06-24 15:23:04.900942+02
66	2	agent-007	t	{"name": "Grace"}	{"greeting": "Happy Wednesday, Grace!"}	\N	2026-06-24 15:23:04.904873+02
67	2	agent-007	t	{"name": "Grace"}	{"greeting": "Happy Wednesday, Grace!"}	\N	2026-06-24 15:23:04.909074+02
68	2	markus	t	{"name": "Ada"}	{"greeting": "Happy Wednesday, Ada!"}	\N	2026-06-24 15:23:04.913188+02
69	2	markus	t	{"name": "Linus"}	{"greeting": "Happy Wednesday, Linus!"}	\N	2026-06-24 15:23:04.917227+02
70	2	agent-007	t	{"name": "Linus"}	{"greeting": "Happy Wednesday, Linus!"}	\N	2026-06-24 15:23:04.921236+02
71	2	markus	t	{"name": "Grace"}	{"greeting": "Happy Wednesday, Grace!"}	\N	2026-06-24 15:23:04.925388+02
72	2	agent-007	t	{"name": "Linus"}	{"greeting": "Happy Wednesday, Linus!"}	\N	2026-06-24 15:23:04.929691+02
73	2	markus	t	{"name": "Grace"}	{"greeting": "Happy Wednesday, Grace!"}	\N	2026-06-24 15:23:04.933722+02
74	2	markus	t	{"name": "Ada"}	{"greeting": "Happy Wednesday, Ada!"}	\N	2026-06-24 15:23:04.937781+02
75	2	agent-007	t	{"name": "Ada"}	{"greeting": "Happy Wednesday, Ada!"}	\N	2026-06-24 15:23:04.941855+02
76	2	markus	t	{"name": "Linus"}	{"greeting": "Happy Wednesday, Linus!"}	\N	2026-06-24 15:23:04.946035+02
77	2	markus	t	{"name": "Linus"}	{"greeting": "Happy Wednesday, Linus!"}	\N	2026-06-24 15:23:04.949981+02
78	2	markus	t	{"name": "Grace"}	{"greeting": "Happy Wednesday, Grace!"}	\N	2026-06-24 15:23:04.953923+02
79	2	markus	t	{"name": "Ada"}	{"greeting": "Happy Wednesday, Ada!"}	\N	2026-06-24 15:23:04.958064+02
80	2	agent-007	t	{"name": "Linus"}	{"greeting": "Happy Wednesday, Linus!"}	\N	2026-06-24 15:23:04.962152+02
81	3	agent-007	t	{"city": "Hamburg"}	{"city": "Hamburg", "population": 1906000}	\N	2026-06-24 15:23:04.969814+02
82	3	anonymous	f	{"city": "Atlantis"}	\N	ValueError: Unknown city; only major German cities are supported.	2026-06-24 15:23:04.973936+02
83	3	agent-007	t	{"city": "Munich"}	{"city": "Munich", "population": 1488000}	\N	2026-06-24 15:23:04.978151+02
84	3	agent-007	f	{"city": "Marburg"}	\N	ValueError: Population below the supported 90,000 threshold.	2026-06-24 15:23:04.982333+02
85	3	anonymous	f	{"city": "Atlantis"}	\N	ValueError: Unknown city; only major German cities are supported.	2026-06-24 15:23:04.986451+02
86	3	anonymous	f	{"city": "Atlantis"}	\N	ValueError: Unknown city; only major German cities are supported.	2026-06-24 15:23:04.990578+02
87	3	markus	f	{"city": "Marburg"}	\N	ValueError: Population below the supported 90,000 threshold.	2026-06-24 15:23:04.994772+02
88	3	anonymous	f	{"city": "Atlantis"}	\N	ValueError: Unknown city; only major German cities are supported.	2026-06-24 15:23:04.998766+02
89	3	agent-007	t	{"city": "Hamburg"}	{"city": "Hamburg", "population": 1906000}	\N	2026-06-24 15:23:05.002845+02
90	3	agent-007	f	{"city": "Marburg"}	\N	ValueError: Population below the supported 90,000 threshold.	2026-06-24 15:23:05.006953+02
91	3	markus	f	{"city": "Atlantis"}	\N	ValueError: Unknown city; only major German cities are supported.	2026-06-24 15:23:05.011177+02
92	3	agent-007	f	{"city": "Marburg"}	\N	ValueError: Population below the supported 90,000 threshold.	2026-06-24 15:23:05.015331+02
93	3	anonymous	t	{"city": "Hamburg"}	{"city": "Hamburg", "population": 1906000}	\N	2026-06-24 15:23:05.019516+02
94	3	anonymous	t	{"city": "Leipzig"}	{"city": "Leipzig", "population": 597000}	\N	2026-06-24 15:23:05.023642+02
95	3	markus	f	{"city": "Atlantis"}	\N	ValueError: Unknown city; only major German cities are supported.	2026-06-24 15:23:05.027894+02
96	3	anonymous	t	{"city": "Leipzig"}	{"city": "Leipzig", "population": 597000}	\N	2026-06-24 15:23:05.031976+02
97	3	anonymous	t	{"city": "Leipzig"}	{"city": "Leipzig", "population": 597000}	\N	2026-06-24 15:23:05.036161+02
98	3	agent-007	t	{"city": "Hamburg"}	{"city": "Hamburg", "population": 1906000}	\N	2026-06-24 15:23:05.040226+02
99	3	markus	t	{"city": "Berlin"}	{"city": "Berlin", "population": 3677000}	\N	2026-06-24 15:23:05.044677+02
100	3	markus	t	{"city": "Berlin"}	{"city": "Berlin", "population": 3677000}	\N	2026-06-24 15:23:05.04935+02
101	3	agent-007	f	{"city": "Marburg"}	\N	ValueError: Population below the supported 90,000 threshold.	2026-06-24 15:23:05.053532+02
102	3	markus	t	{"city": "Leipzig"}	{"city": "Leipzig", "population": 597000}	\N	2026-06-24 15:23:05.057697+02
103	3	markus	t	{"city": "Leipzig"}	{"city": "Leipzig", "population": 597000}	\N	2026-06-24 15:23:05.061974+02
104	3	agent-007	f	{"city": "Marburg"}	\N	ValueError: Population below the supported 90,000 threshold.	2026-06-24 15:23:05.066149+02
105	3	markus	f	{"city": "Atlantis"}	\N	ValueError: Unknown city; only major German cities are supported.	2026-06-24 15:23:05.070412+02
106	3	markus	t	{"city": "Hamburg"}	{"city": "Hamburg", "population": 1906000}	\N	2026-06-24 15:23:05.07494+02
107	3	anonymous	t	{"city": "Berlin"}	{"city": "Berlin", "population": 3677000}	\N	2026-06-24 15:23:05.079435+02
108	3	markus	t	{"city": "Hamburg"}	{"city": "Hamburg", "population": 1906000}	\N	2026-06-24 15:23:05.083455+02
109	3	markus	t	{"city": "Hamburg"}	{"city": "Hamburg", "population": 1906000}	\N	2026-06-24 15:23:05.087589+02
110	3	markus	t	{"city": "Leipzig"}	{"city": "Leipzig", "population": 597000}	\N	2026-06-24 15:23:05.092045+02
111	3	markus	t	{"city": "Leipzig"}	{"city": "Leipzig", "population": 597000}	\N	2026-06-24 15:23:05.096086+02
112	3	agent-007	f	{"city": "Marburg"}	\N	ValueError: Population below the supported 90,000 threshold.	2026-06-24 15:23:05.100126+02
113	3	agent-007	f	{"city": "Marburg"}	\N	ValueError: Population below the supported 90,000 threshold.	2026-06-24 15:23:05.104228+02
114	3	agent-007	t	{"city": "Munich"}	{"city": "Munich", "population": 1488000}	\N	2026-06-24 15:23:05.108423+02
115	3	markus	f	{"city": "Atlantis"}	\N	ValueError: Unknown city; only major German cities are supported.	2026-06-24 15:23:05.112678+02
116	3	anonymous	f	{"city": "Atlantis"}	\N	ValueError: Unknown city; only major German cities are supported.	2026-06-24 15:23:05.11674+02
117	3	agent-007	t	{"city": "Munich"}	{"city": "Munich", "population": 1488000}	\N	2026-06-24 15:23:05.120751+02
118	3	markus	t	{"city": "Berlin"}	{"city": "Berlin", "population": 3677000}	\N	2026-06-24 15:23:05.124936+02
119	3	agent-007	f	{"city": "Atlantis"}	\N	ValueError: Unknown city; only major German cities are supported.	2026-06-24 15:23:05.129147+02
120	3	anonymous	t	{"city": "Leipzig"}	{"city": "Leipzig", "population": 597000}	\N	2026-06-24 15:23:05.133193+02
121	4	markus	t	{"address": "10 Downing St"}	{"lat": 50.9, "lon": 8.0}	\N	2026-06-24 15:23:05.142813+02
122	4	agent-007	f	{"address": "Hauptstr 1, Berlin"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.147034+02
123	4	markus	t	{"address": "Marktplatz, Marburg"}	{"lat": 50.2, "lon": 8.3}	\N	2026-06-24 15:23:05.151096+02
124	4	anonymous	t	{"address": "10 Downing St"}	{"lat": 50.9, "lon": 8.0}	\N	2026-06-24 15:23:05.155456+02
125	4	anonymous	f	{"address": "Hauptstr 1, Berlin"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.159686+02
126	4	agent-007	t	{"address": "Marktplatz, Marburg"}	{"lat": 50.2, "lon": 8.3}	\N	2026-06-24 15:23:05.163825+02
127	4	anonymous	f	{"address": "MIT, Cambridge"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.167936+02
128	4	agent-007	t	{"address": "10 Downing St"}	{"lat": 50.9, "lon": 8.0}	\N	2026-06-24 15:23:05.171928+02
129	4	markus	f	{"address": "Unknownville 42"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.176048+02
130	4	anonymous	f	{"address": "MIT, Cambridge"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.180344+02
131	4	markus	f	{"address": "Hauptstr 1, Berlin"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.184556+02
132	4	anonymous	t	{"address": "10 Downing St"}	{"lat": 50.9, "lon": 8.0}	\N	2026-06-24 15:23:05.188675+02
133	4	markus	f	{"address": "MIT, Cambridge"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.192902+02
134	4	anonymous	t	{"address": "10 Downing St"}	{"lat": 50.9, "lon": 8.0}	\N	2026-06-24 15:23:05.197034+02
135	4	markus	f	{"address": "MIT, Cambridge"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.201016+02
136	4	anonymous	f	{"address": "MIT, Cambridge"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.204986+02
137	4	markus	f	{"address": "Unknownville 42"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.209078+02
138	4	agent-007	t	{"address": "Marktplatz, Marburg"}	{"lat": 50.2, "lon": 8.3}	\N	2026-06-24 15:23:05.213195+02
139	4	anonymous	t	{"address": "10 Downing St"}	{"lat": 50.9, "lon": 8.0}	\N	2026-06-24 15:23:05.217273+02
140	4	markus	t	{"address": "10 Downing St"}	{"lat": 50.9, "lon": 8.0}	\N	2026-06-24 15:23:05.221565+02
141	4	anonymous	f	{"address": "MIT, Cambridge"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.225861+02
142	4	markus	f	{"address": "Unknownville 42"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.23007+02
143	4	markus	f	{"address": "Hauptstr 1, Berlin"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.234112+02
144	4	agent-007	f	{"address": "Unknownville 42"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.238015+02
145	4	agent-007	f	{"address": "MIT, Cambridge"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.242127+02
146	4	markus	t	{"address": "10 Downing St"}	{"lat": 50.9, "lon": 8.0}	\N	2026-06-24 15:23:05.246328+02
147	4	agent-007	t	{"address": "Marktplatz, Marburg"}	{"lat": 50.2, "lon": 8.3}	\N	2026-06-24 15:23:05.250435+02
148	4	markus	f	{"address": "MIT, Cambridge"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.254547+02
149	4	anonymous	t	{"address": "Marktplatz, Marburg"}	{"lat": 50.2, "lon": 8.3}	\N	2026-06-24 15:23:05.258719+02
150	4	markus	t	{"address": "10 Downing St"}	{"lat": 50.9, "lon": 8.0}	\N	2026-06-24 15:23:05.263002+02
151	4	anonymous	f	{"address": "MIT, Cambridge"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.266933+02
152	4	anonymous	f	{"address": "Hauptstr 1, Berlin"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.270943+02
153	4	agent-007	t	{"address": "Marktplatz, Marburg"}	{"lat": 50.2, "lon": 8.3}	\N	2026-06-24 15:23:05.275305+02
154	4	agent-007	f	{"address": "MIT, Cambridge"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.279531+02
155	4	agent-007	f	{"address": "Unknownville 42"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.283675+02
156	4	agent-007	t	{"address": "Marktplatz, Marburg"}	{"lat": 50.2, "lon": 8.3}	\N	2026-06-24 15:23:05.287742+02
157	4	anonymous	f	{"address": "MIT, Cambridge"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:23:05.291939+02
158	4	anonymous	t	{"address": "10 Downing St"}	{"lat": 50.9, "lon": 8.0}	\N	2026-06-24 15:23:05.296096+02
159	4	anonymous	t	{"address": "Marktplatz, Marburg"}	{"lat": 50.2, "lon": 8.3}	\N	2026-06-24 15:23:05.300043+02
160	4	markus	t	{"address": "Marktplatz, Marburg"}	{"lat": 50.2, "lon": 8.3}	\N	2026-06-24 15:23:05.304038+02
161	3	anonymous	t	{"city": "Berlin"}	{"city": "Berlin", "population": 3677000}	\N	2026-06-24 15:31:25.701712+02
162	4	anonymous	f	{"address": "Französische Allee 17, 72072, Tübingen"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:34:34.050454+02
163	4	anonymous	f	{"address": "Französische Allee 17, 72072, Tübingen, Germany"}	\N	RuntimeError: Address not found in the geocoding index.	2026-06-24 15:34:42.151822+02
164	4	anonymous	t	{"address": "Französische Allee 17, 72072 Tübingen"}	{"lat": 50.3, "lon": 8.0}	\N	2026-06-24 16:30:12.219266+02
165	4	anonymous	f	{"address": "Französische Allee 17, 72072 Tübingen"}	\N	ModuleNotFoundError: No module named 'dotenv'	2026-06-24 17:11:29.211124+02
166	4	anonymous	f	{"address": "Französische Allee 17, Tübingen"}	\N	ModuleNotFoundError: No module named 'dotenv'	2026-06-24 17:12:17.495648+02
167	4	anonymous	f	{"address": ""}	\N	ModuleNotFoundError: No module named 'dotenv'	2026-06-24 17:12:48.739733+02
168	4	anonymous	t	{"address": "Französische Allee 17, Tübingen"}	{"lat": 48.527, "lon": 9.067}	\N	2026-06-24 17:13:27.178381+02
169	4	anonymous	t	{"address": "MLcon 2026, Munich"}	{"lat": 48.1351, "lon": 11.582}	\N	2026-06-24 17:14:07.08506+02
\.


--
-- Data for Name: tools; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tools (id, name, description, inputs, outputs, conditions, code, created_at) FROM stdin;
1	Reverse String	Reverses the characters of the given text.	{"text": "The text to reverse."}	{'reversed': <reversed text>}	Always works for any text input.	from tool_base import Tool\n\n\nclass ReverseString(Tool):\n    name = "Reverse String"\n    description = "Reverses the characters of the given text."\n    inputs = {"text": "The text to reverse."}\n    outputs = "{'reversed': <reversed text>}"\n\n    def run(self, parameters):\n        return {"reversed": parameters["text"][::-1]}\n	2026-06-24 15:23:04.638799+02
2	Wednesday Greeting	Greets the user, but only succeeds on Wednesdays.	{"name": "Who to greet."}	{'greeting': <text>}	Only succeeds on Wednesdays (server local time).	from tool_base import Tool\nimport datetime\n\n\nclass WednesdayGreeting(Tool):\n    name = "Wednesday Greeting"\n    description = "Greets the user, but only succeeds on Wednesdays."\n    inputs = {"name": "Who to greet."}\n    outputs = "{'greeting': <text>}"\n\n    def run(self, parameters):\n        today = datetime.date.today()\n        if today.weekday() != 2:  # Monday=0 ... Wednesday=2\n            raise RuntimeError("This tool only works on Wednesdays.")\n        return {"greeting": "Happy Wednesday, %s!" % parameters["name"]}\n	2026-06-24 15:23:04.799773+02
3	German City Population	Returns the approximate population of a large German city.	{"city": "Name of a German city (e.g. Berlin)."}	{'city': <name>, 'population': <int>}	Only German cities with population > 90,000.	from tool_base import Tool\n\n\nclass GermanCityPopulation(Tool):\n    name = "German City Population"\n    description = "Returns the approximate population of a large German city."\n    inputs = {"city": "Name of a German city (e.g. Berlin)."}\n    outputs = "{'city': <name>, 'population': <int>}"\n\n    _POP = {\n        "berlin": 3677000, "hamburg": 1906000, "munich": 1488000,\n        "cologne": 1073000, "frankfurt": 759000, "stuttgart": 626000,\n        "duesseldorf": 619000, "leipzig": 597000, "dortmund": 588000,\n        "marburg": 77000,  # below the 90k threshold on purpose\n    }\n\n    def run(self, parameters):\n        city = parameters["city"].strip().lower()\n        if city not in self._POP:\n            raise ValueError("Unknown city; only major German cities are supported.")\n        pop = self._POP[city]\n        if pop < 90000:\n            raise ValueError("Population below the supported 90,000 threshold.")\n        return {"city": parameters["city"].title(), "population": pop}\n	2026-06-24 15:23:04.966217+02
4	Geocoder	Resolves an address to coordinates using an LLM (nebius chat).	{"address": "A free-text address."}	{'lat': <float>, 'lon': <float>}	Coverage is incomplete; ~65% of addresses resolve.	from tool_base import Tool\nimport json\nimport re\n\nfrom nebius import get_chat_response\n\n\nclass FlakyGeocoder(Tool):\n    name = "Flaky Geocoder"\n    description = "Resolves an address to coordinates using an LLM (nebius chat)."\n    inputs = {"address": "A free-text address."}\n    outputs = "{'lat': <float>, 'lon': <float>}"\n\n    def run(self, parameters):\n        addr = parameters["address"].strip()\n        prompt = (\n            "You are a geocoder. Given an address, respond with ONLY a JSON "\n            "object of the form {\\"lat\\": <float>, \\"lon\\": <float>} giving its "\n            "approximate latitude and longitude. No prose, no code fences.\\n\\n"\n            "Address: " + addr\n        )\n        answer = get_chat_response(prompt)\n\n        match = re.search(r"\\{.*\\}", answer, re.DOTALL)\n        if not match:\n            raise RuntimeError("Address not found in the geocoding index.")\n        data = json.loads(match.group(0))\n        return {"lat": float(data["lat"]), "lon": float(data["lon"])}\n	2026-06-24 15:23:05.138974+02
\.


--
-- Name: runs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.runs_id_seq', 169, true);


--
-- Name: tools_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tools_id_seq', 4, true);


--
-- Name: runs runs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runs
    ADD CONSTRAINT runs_pkey PRIMARY KEY (id);


--
-- Name: tools tools_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tools
    ADD CONSTRAINT tools_pkey PRIMARY KEY (id);


--
-- Name: runs_tool_id_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX runs_tool_id_idx ON public.runs USING btree (tool_id);


--
-- Name: runs runs_tool_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.runs
    ADD CONSTRAINT runs_tool_id_fkey FOREIGN KEY (tool_id) REFERENCES public.tools(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict BgqJqWMXzTutnkgdveMpjj5oRk32742ci8PRYkaXAYhO2wDtYlNJ0aYZIrWGlWq

