--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: add_customer(character varying, character varying, character varying, character varying, text, character varying, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_customer(IN p_first_name character varying, IN p_last_name character varying, IN p_phone_no character varying, IN p_email_address character varying, IN p_address text, IN p_village_name character varying, IN p_veterinarian_full_name character varying)
    LANGUAGE plpgsql
    AS $$
declare
    v_village_id int;
    v_veterinarian_id int;
    v_customer_id int;
begin
    select id
    into v_village_id
    from villages
    where lower("name") = lower(p_village_name);

    select id
    into v_veterinarian_id
    from veterinarians
    where trim(concat(lower(first_name),' ',lower("last_name"))) = trim(lower(p_veterinarian_full_name));
    
    
    insert into customers (first_name,last_name,phone_no,email_address,address,village_id)
    values (p_first_name,p_last_name,p_phone_no,p_email_address,p_address,v_village_id)
    returning id into v_customer_id;
    
    insert into vet_customers (veterinarian_id,customer_id)
    values(v_veterinarian_id,v_customer_id);
    
end;

$$;


ALTER PROCEDURE public.add_customer(IN p_first_name character varying, IN p_last_name character varying, IN p_phone_no character varying, IN p_email_address character varying, IN p_address text, IN p_village_name character varying, IN p_veterinarian_full_name character varying) OWNER TO postgres;

--
-- Name: add_sale(character varying, integer, date); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_sale(IN p_product_name character varying, IN p_quantity integer, IN p_sale_date date DEFAULT CURRENT_DATE)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_product_id int;
    v_price numeric(10,2);
begin
    select product_id,price
    into v_product_id,v_price
    from products 
    where lower("name") = lower(p_product_name);
    
    insert into sales ("product_id",quantity,sale_date,price)
    values (v_product_id,p_quantity,p_sale_date,(p_quantity * v_price));
end;
$$;


ALTER PROCEDURE public.add_sale(IN p_product_name character varying, IN p_quantity integer, IN p_sale_date date) OWNER TO postgres;

--
-- Name: add_veterinarian(character varying, character varying, character varying, character varying, text, character varying, date); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_veterinarian(IN p_first_name character varying, IN p_last_name character varying, IN phone_no character varying, IN email_address character varying, IN address text, IN p_specialization_name character varying, IN registration_date date DEFAULT CURRENT_DATE)
    LANGUAGE plpgsql
    AS $$
declare
    v_specialization_id int;
    v_veterinarian_id int;
begin
    
    select id
    into v_specialization_id
    from specializations
    where trim(lower("name")) = trim(lower(p_specialization_name));

    if v_specialization_id is not null then
        insert into veterinarians ("first_name",last_name,phone_no,email_address,address,registration_date)
        values(p_first_name,
        p_last_name,
        phone_no,
        email_address,
        address,
        registration_date
        ) returning id into v_veterinarian_id;
        
        insert into vet_specializations (veterinarian_id,specialization_id)values(v_veterinarian_id,v_specialization_id);
    else
        raise exception 'Specialization with the name "%" does not exist',p_specialization_name;
    end if;
end;
$$;


ALTER PROCEDURE public.add_veterinarian(IN p_first_name character varying, IN p_last_name character varying, IN phone_no character varying, IN email_address character varying, IN address text, IN p_specialization_name character varying, IN registration_date date) OWNER TO postgres;

--
-- Name: add_village(character varying, character, character varying); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.add_village(IN p_village_name character varying, IN p_postal_code character, IN p_district_name character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_district_id int;
begin
    select id 
    into v_district_id
    from districts
    where lower("name") = lower(p_district_name);
    
    if v_district_id is not null then
        insert into villages ("name",postal_code,district_id) values(p_village_name,p_postal_code,v_district_id);
    
    else
        raise exception 'District with the name of "%" does not exist',p_district_name;
    end if;
end;
$$;


ALTER PROCEDURE public.add_village(IN p_village_name character varying, IN p_postal_code character, IN p_district_name character varying) OWNER TO postgres;

--
-- Name: check_veterinarian(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_veterinarian() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    v_veterinarian_id int;
begin
    select id
    into v_veterinarian_id
    from veterinarians
    where id = new.veterinarian_id;
    
    
    if v_veterinarian_id is null then
        raise exception 'Veterinarian with the id of "%" does not exists',v_veterinarian_id;
    else
        return new;
    end if;
end;
$$;


ALTER FUNCTION public.check_veterinarian() OWNER TO postgres;

--
-- Name: check_village(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_village() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    v_village_id int;
begin
    select id
    into v_village_id
    from villages
    where id = NEW.village_id;
    
    if v_village_id is null then
        raise exception 'Village "%" information is not correct',v_village_id;
    else
        return new;
    end if;
end;
$$;


ALTER FUNCTION public.check_village() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: animal_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animal_product (
    id integer NOT NULL,
    animal_type_id integer NOT NULL,
    product_id integer NOT NULL
);


ALTER TABLE public.animal_product OWNER TO postgres;

--
-- Name: animal_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.animal_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.animal_product_id_seq OWNER TO postgres;

--
-- Name: animal_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.animal_product_id_seq OWNED BY public.animal_product.id;


--
-- Name: animal_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.animal_types (
    id integer NOT NULL,
    species_name character varying(50) NOT NULL
);


ALTER TABLE public.animal_types OWNER TO postgres;

--
-- Name: animal_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.animal_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.animal_type_id_seq OWNER TO postgres;

--
-- Name: animal_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.animal_type_id_seq OWNED BY public.animal_types.id;


--
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cities (
    id integer NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.cities OWNER TO postgres;

--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cities_id_seq OWNER TO postgres;

--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cities_id_seq OWNED BY public.cities.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.companies (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    phone_no character varying(14) NOT NULL,
    email_address character varying(70) NOT NULL,
    address text NOT NULL,
    tax_number character varying(11) NOT NULL
);


ALTER TABLE public.companies OWNER TO postgres;

--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.companies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.companies_id_seq OWNER TO postgres;

--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: company_product; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.company_product (
    company_product_id integer NOT NULL,
    company_id integer NOT NULL,
    product_id integer NOT NULL
);


ALTER TABLE public.company_product OWNER TO postgres;

--
-- Name: company_product_company_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.company_product_company_product_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.company_product_company_product_id_seq OWNER TO postgres;

--
-- Name: company_product_company_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.company_product_company_product_id_seq OWNED BY public.company_product.company_product_id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    phone_no character varying(14) NOT NULL,
    email_address character varying(70),
    address text,
    village_id integer NOT NULL
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.customers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_id_seq OWNER TO postgres;

--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- Name: districts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.districts (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    city_id integer NOT NULL
);


ALTER TABLE public.districts OWNER TO postgres;

--
-- Name: districts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.districts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.districts_id_seq OWNER TO postgres;

--
-- Name: districts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.districts_id_seq OWNED BY public.districts.id;


--
-- Name: foods; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.foods (
    product_id integer NOT NULL,
    calorie integer NOT NULL,
    weight numeric(8,3) NOT NULL,
    is_dry boolean NOT NULL
);


ALTER TABLE public.foods OWNER TO postgres;

--
-- Name: medicine_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medicine_categories (
    id integer NOT NULL,
    category character varying(40) NOT NULL
);


ALTER TABLE public.medicine_categories OWNER TO postgres;

--
-- Name: medicine_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.medicine_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.medicine_categories_id_seq OWNER TO postgres;

--
-- Name: medicine_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.medicine_categories_id_seq OWNED BY public.medicine_categories.id;


--
-- Name: medicines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medicines (
    product_id integer NOT NULL,
    usage_instruction character varying(50) NOT NULL,
    medicine_category_id integer,
    dosage integer NOT NULL
);


ALTER TABLE public.medicines OWNER TO postgres;

--
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    product_id integer NOT NULL,
    name character varying(50) NOT NULL,
    product_type character(1) NOT NULL,
    price numeric(10,2) NOT NULL,
    CONSTRAINT products_product_type_check CHECK ((product_type = ANY (ARRAY['M'::bpchar, 'F'::bpchar])))
);


ALTER TABLE public.products OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.products_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.products_id_seq OWNER TO postgres;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.product_id;


--
-- Name: purchases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.purchases (
    id integer NOT NULL,
    company_id integer NOT NULL,
    product_id integer NOT NULL,
    purchase_date date NOT NULL,
    arrival_date date,
    quantity integer NOT NULL,
    price numeric(10,2) NOT NULL,
    CONSTRAINT check_quantity CHECK ((quantity >= 0))
);


ALTER TABLE public.purchases OWNER TO postgres;

--
-- Name: purchases_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.purchases_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.purchases_id_seq OWNER TO postgres;

--
-- Name: purchases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.purchases_id_seq OWNED BY public.purchases.id;


--
-- Name: sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales (
    id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    sale_date date NOT NULL,
    price numeric(10,2) NOT NULL,
    CONSTRAINT check_quantity CHECK ((quantity >= 0))
);


ALTER TABLE public.sales OWNER TO postgres;

--
-- Name: sales_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sales_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sales_id_seq OWNER TO postgres;

--
-- Name: sales_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sales_id_seq OWNED BY public.sales.id;


--
-- Name: specializations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.specializations (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    specialization_type_id integer NOT NULL
);


ALTER TABLE public.specializations OWNER TO postgres;

--
-- Name: specialization_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.specialization_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.specialization_id_seq OWNER TO postgres;

--
-- Name: specialization_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.specialization_id_seq OWNED BY public.specializations.id;


--
-- Name: specialization_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.specialization_types (
    id integer NOT NULL,
    description character varying(50) NOT NULL,
    abbreviation character varying(50) NOT NULL
);


ALTER TABLE public.specialization_types OWNER TO postgres;

--
-- Name: specialization_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.specialization_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.specialization_type_id_seq OWNER TO postgres;

--
-- Name: specialization_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.specialization_type_id_seq OWNED BY public.specialization_types.id;


--
-- Name: stocks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stocks (
    id integer NOT NULL,
    product_id integer NOT NULL,
    expiration_date date NOT NULL,
    quantity integer NOT NULL,
    CONSTRAINT check_stock_quantity CHECK ((quantity >= 0))
);


ALTER TABLE public.stocks OWNER TO postgres;

--
-- Name: stocks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.stocks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stocks_id_seq OWNER TO postgres;

--
-- Name: stocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.stocks_id_seq OWNED BY public.stocks.id;


--
-- Name: vet_customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vet_customers (
    id integer NOT NULL,
    veterinarian_id integer NOT NULL,
    customer_id integer NOT NULL
);


ALTER TABLE public.vet_customers OWNER TO postgres;

--
-- Name: vet_customers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vet_customers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vet_customers_id_seq OWNER TO postgres;

--
-- Name: vet_customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vet_customers_id_seq OWNED BY public.vet_customers.id;


--
-- Name: vet_specializations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vet_specializations (
    id integer NOT NULL,
    veterinarian_id integer NOT NULL,
    specialization_id integer NOT NULL
);


ALTER TABLE public.vet_specializations OWNER TO postgres;

--
-- Name: vet_specializations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vet_specializations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vet_specializations_id_seq OWNER TO postgres;

--
-- Name: vet_specializations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vet_specializations_id_seq OWNED BY public.vet_specializations.id;


--
-- Name: veterinarians; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.veterinarians (
    id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    phone_no character varying(14) NOT NULL,
    email_address character varying(70) NOT NULL,
    address text NOT NULL,
    registration_date date NOT NULL
);


ALTER TABLE public.veterinarians OWNER TO postgres;

--
-- Name: veterinarians_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.veterinarians_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.veterinarians_id_seq OWNER TO postgres;

--
-- Name: veterinarians_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.veterinarians_id_seq OWNED BY public.veterinarians.id;


--
-- Name: villages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.villages (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    district_id integer NOT NULL,
    postal_code character(5) NOT NULL
);


ALTER TABLE public.villages OWNER TO postgres;

--
-- Name: villages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.villages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.villages_id_seq OWNER TO postgres;

--
-- Name: villages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.villages_id_seq OWNED BY public.villages.id;


--
-- Name: animal_product id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_product ALTER COLUMN id SET DEFAULT nextval('public.animal_product_id_seq'::regclass);


--
-- Name: animal_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_types ALTER COLUMN id SET DEFAULT nextval('public.animal_type_id_seq'::regclass);


--
-- Name: cities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities ALTER COLUMN id SET DEFAULT nextval('public.cities_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: company_product company_product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_product ALTER COLUMN company_product_id SET DEFAULT nextval('public.company_product_company_product_id_seq'::regclass);


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- Name: districts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts ALTER COLUMN id SET DEFAULT nextval('public.districts_id_seq'::regclass);


--
-- Name: medicine_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicine_categories ALTER COLUMN id SET DEFAULT nextval('public.medicine_categories_id_seq'::regclass);


--
-- Name: products product_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products ALTER COLUMN product_id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: purchases id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases ALTER COLUMN id SET DEFAULT nextval('public.purchases_id_seq'::regclass);


--
-- Name: sales id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales ALTER COLUMN id SET DEFAULT nextval('public.sales_id_seq'::regclass);


--
-- Name: specialization_types id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialization_types ALTER COLUMN id SET DEFAULT nextval('public.specialization_type_id_seq'::regclass);


--
-- Name: specializations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specializations ALTER COLUMN id SET DEFAULT nextval('public.specialization_id_seq'::regclass);


--
-- Name: stocks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stocks ALTER COLUMN id SET DEFAULT nextval('public.stocks_id_seq'::regclass);


--
-- Name: vet_customers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vet_customers ALTER COLUMN id SET DEFAULT nextval('public.vet_customers_id_seq'::regclass);


--
-- Name: vet_specializations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vet_specializations ALTER COLUMN id SET DEFAULT nextval('public.vet_specializations_id_seq'::regclass);


--
-- Name: veterinarians id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.veterinarians ALTER COLUMN id SET DEFAULT nextval('public.veterinarians_id_seq'::regclass);


--
-- Name: villages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.villages ALTER COLUMN id SET DEFAULT nextval('public.villages_id_seq'::regclass);


--
-- Data for Name: animal_product; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.animal_product VALUES
	(1, 1, 1),
	(4, 1, 6),
	(3, 1, 19),
	(2, 1, 12),
	(5, 2, 11),
	(6, 2, 13),
	(7, 2, 4),
	(8, 2, 7),
	(9, 3, 14),
	(10, 3, 2),
	(11, 3, 3),
	(12, 4, 17),
	(13, 4, 5),
	(14, 4, 8),
	(15, 5, 20),
	(16, 5, 9),
	(17, 5, 1),
	(18, 2, 18),
	(19, 3, 16),
	(20, 4, 15),
	(26, 1, 22),
	(27, 2, 22),
	(28, 2, 23);


--
-- Data for Name: animal_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.animal_types VALUES
	(1, 'Dog'),
	(2, 'Cat'),
	(3, 'Cow'),
	(4, 'Sheep'),
	(5, 'Horse');


--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cities VALUES
	(1, 'Çanakkale'),
	(2, 'Balıkesir');


--
-- Data for Name: companies; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.companies VALUES
	(2, 'Uriel Pharmacy Inc.', '101-597-4782', 'nslaney0@networksolutions.com', '173 Eastlawn Place', '1294876215'),
	(3, 'Legacy Pharmaceutical Packaging', '108-264-2888', 'rconneely1@qq.com', '57 Spaight Street', '8476210382'),
	(4, 'Novartis Consumer Health, Inc.', '902-956-3418', 'lgwatkin2@domainmarket.com', '613 Daystar Hill', '2938475162'),
	(5, 'Mylan Pharmaceuticals Inc.', '841-649-2653', 'mmccreery3@uiuc.edu', '15436 Village Parkway', '1204857963'),
	(6, 'Lannett Company, Inc.', '852-743-9132', 'gwoolway4@miitbeian.gov.cn', '14 Dexter Hill', '9047612384'),
	(7, 'AhmetPharmacy', '0-523-333-2442', 'PharmacyAhmet@hotmail.com', '8112 Serdivan ', '1234567892');


--
-- Data for Name: company_product; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.company_product VALUES
	(1, 2, 3),
	(2, 2, 6),
	(3, 2, 11),
	(4, 3, 20),
	(5, 3, 5),
	(6, 3, 7),
	(7, 4, 14),
	(8, 4, 9),
	(9, 4, 11),
	(10, 5, 8),
	(11, 5, 10),
	(12, 6, 1),
	(13, 6, 2),
	(14, 6, 4),
	(15, 6, 12),
	(16, 2, 13),
	(17, 3, 15),
	(18, 4, 17),
	(19, 5, 16),
	(20, 6, 18),
	(21, 2, 19),
	(22, 3, 20),
	(23, 7, 1),
	(24, 7, 10),
	(25, 7, 15),
	(26, 7, 16);


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.customers VALUES
	(8, 'Rosamund', 'Wheway', '0-581-183-1982', 'rwheway0@wufoo.com', NULL, 5),
	(9, 'Maxine', 'Fullick', '0-519-434-2656', 'mfullick1@nba.com', '8855 Lotheville Street', 6),
	(10, 'Guilbert', 'Kirgan', '0-543-943-3311', NULL, NULL, 7),
	(11, 'Florie', 'Kinson', '0-543-537-5889', 'fkinson3@mapquest.com', '7 Susan Drive', 8),
	(12, 'Ashia', 'Ginley', '0-564-521-6063', 'aginley4@microsoft.com', '57 Heffernan Court', 9),
	(13, 'Rozamond', 'Voase', '0-577-797-8482', NULL, '1322 Grasskamp Junction', 10),
	(14, 'Christos', 'Dyte', '0-593-885-9468', 'cdyte6@whitehouse.gov', NULL, 8),
	(16, 'Wash', 'Le Pine', '0-578-747-3587', 'wlepine8@elegantthemes.com', '8 North Hill', 6),
	(17, 'Ozzie', 'Linkin', '0-580-666-6564', 'olinkin9@sciencedaily.com', '7363 Canary Junction', 7),
	(53, 'Diego', 'Kedioğlu', '0-525-313-2442', 'diegoKedioğlu@hotmail.com', '121 Şirintepe', 8);


--
-- Data for Name: districts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.districts VALUES
	(1, 'Biga', 1),
	(2, 'Gönen', 2);


--
-- Data for Name: foods; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.foods VALUES
	(11, 200, 3000.000, true),
	(12, 400, 5000.000, false),
	(13, 100, 1000.000, false),
	(14, 150, 2000.000, true),
	(15, 220, 2500.000, true),
	(16, 80, 3500.000, true),
	(17, 50, 500.000, true),
	(18, 210, 3300.000, false),
	(19, 100, 4000.000, false),
	(20, 130, 2000.000, true),
	(23, 100, 500.000, false);


--
-- Data for Name: medicine_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.medicine_categories VALUES
	(1, 'Antibiotic'),
	(3, 'Vitamin'),
	(4, 'Mineral'),
	(2, 'Pain Reliever'),
	(5, 'Vaccines'),
	(6, 'Cardiovascular Drugs'),
	(7, 'Gastrointestinal Drugs'),
	(8, 'Anesthetics and Sedatives'),
	(9, 'Antifungal Drugs');


--
-- Data for Name: medicines; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.medicines VALUES
	(1, 'Store in a cool, dry place', 5, 10),
	(2, 'Serve fresh water alongside', 3, 500),
	(3, 'Feed twice daily as directed', 1, 500),
	(4, 'Store in a cool, dry place', 5, 10),
	(5, 'Refrigerate after opening', 6, 100),
	(6, 'Mix with wet food for variety', 4, 200),
	(7, 'Use before the expiration date', 8, 20),
	(8, 'Do not feed to kittens under 6 months', 7, 400),
	(9, 'Keep packaging sealed tightly', 2, 150),
	(10, 'Shake well before serving', 9, 250),
	(22, 'Shake Very well before serving', 1, 100);


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.products VALUES
	(1, 'Purminerals SPF 15 Blush Medium', 'M', 7.72),
	(3, 'Doxepin Hydrochloride', 'M', 9.32),
	(5, 'Eucerin ', 'M', 6.66),
	(6, 'Clobetasol Propionate', 'M', 8.77),
	(8, 'Leader Anti Diarrheal', 'M', 8.21),
	(9, 'Atropine Sulfate', 'M', 7.98),
	(10, 'care one pain relief', 'M', 8.48),
	(11, 'Whiskas Dry Cat Food', 'F', 12.99),
	(13, 'Royal Canin Kitten Food', 'F', 18.30),
	(14, 'Purina ONE SmartBlend', 'F', 21.99),
	(15, 'Hills Science Diet', 'F', 26.75),
	(16, 'Blue Buffalo Life Protection', 'F', 33.99),
	(17, 'Iams ProActive Health', 'F', 19.20),
	(18, 'Nutro Ultra Small Breed', 'F', 28.00),
	(19, 'Orijen Original Dog Food', 'F', 45.99),
	(20, 'Horse Care Oats', 'F', 38.50),
	(4, 'Kadian', 'M', 5.35),
	(2, 'Dr Tichenors', 'M', 9.20),
	(12, 'Pedigree Adult Dog Food', 'F', 24.50),
	(22, 'Augmentin', 'M', 150.00),
	(23, 'Mama', 'F', 50.00),
	(7, 'Diclofenac Sodium', 'M', 20.00);


--
-- Data for Name: purchases; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.purchases VALUES
	(1, 5, 19, '2015-02-02', '2015-02-05', 50, 14.98),
	(2, 3, 6, '2016-05-31', '2016-06-12', 42, 12.02),
	(3, 5, 16, '2016-09-06', '2016-09-12', 22, 8.78),
	(4, 6, 9, '2016-11-12', '2016-11-25', 32, 23.23),
	(5, 2, 5, '2017-05-07', '2017-05-15', 44, 13.43),
	(6, 5, 18, '2017-10-19', '2017-10-23', 77, 28.43),
	(7, 4, 11, '2018-02-07', '2018-02-10', 88, 15.65),
	(8, 6, 20, '2018-05-07', '2018-05-13', 21, 9.36),
	(9, 2, 1, '2019-09-20', '2019-09-24', 32, 18.31),
	(10, 6, 15, '2020-01-25', '2020-02-01', 43, 10.53),
	(11, 3, 7, '2021-07-14', '2021-07-20', 53, 10.18),
	(12, 4, 13, '2022-02-11', '2022-02-15', 44, 19.29),
	(13, 2, 2, '2022-06-26', '2022-06-28', 23, 14.46),
	(14, 4, 12, '2023-03-12', '2023-03-17', 12, 25.61),
	(15, 3, 10, '2023-06-10', '2023-06-29', 13, 25.28),
	(16, 2, 3, '2023-11-06', '2023-11-15', 43, 7.41),
	(17, 5, 17, '2024-01-27', '2024-02-02', 55, 29.98),
	(18, 4, 14, '2024-04-02', '2024-04-06', 66, 15.59),
	(19, 3, 8, '2024-04-30', '2024-05-07', 77, 20.91),
	(20, 6, 4, '2024-05-21', '2024-06-01', 12, 28.00),
	(21, 2, 3, '2024-12-13', '2024-12-13', 32, 298.24);


--
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.sales VALUES
	(1, 1, 20, '2015-09-15', 18.67),
	(2, 2, 15, '2022-07-22', 17.27),
	(3, 3, 5, '2022-06-08', 8.31),
	(4, 15, 2, '2017-03-09', 38.37),
	(5, 16, 1, '2024-04-16', 24.89),
	(6, 17, 1, '2023-04-18', 15.16),
	(7, 18, 3, '2017-05-03', 35.57),
	(8, 19, 5, '2017-05-22', 38.34),
	(9, 20, 4, '2022-08-30', 24.72),
	(10, 4, 12, '2018-11-29', 28.76),
	(11, 5, 20, '2021-03-29', 39.73),
	(12, 6, 13, '2019-05-26', 23.69),
	(13, 7, 43, '2016-10-06', 28.14),
	(14, 8, 7, '2022-06-21', 20.84),
	(15, 9, 13, '2016-04-01', 19.24),
	(16, 10, 21, '2017-10-20', 14.82),
	(17, 11, 2, '2020-09-29', 21.31),
	(18, 12, 1, '2022-11-01', 8.60),
	(19, 14, 9, '2021-05-04', 44.85),
	(20, 13, 2, '2024-08-21', 16.84),
	(22, 4, 12, '2024-12-03', 64.20),
	(26, 2, 1, '2024-12-03', 9.20),
	(27, 2, 5, '2024-12-03', 46.00),
	(29, 12, 20, '2024-02-12', 490.00),
	(30, 12, 20, '2024-12-04', 490.00),
	(44, 15, 2, '2024-12-10', 53.50),
	(45, 15, 3, '2024-12-10', 80.25),
	(46, 8, 5, '2024-12-14', 41.05);


--
-- Data for Name: specialization_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.specialization_types VALUES
	(1, 'Clinical and Surgical Speciality', 'CASS'),
	(2, 'Speciality Based On Animal Species', 'SBAS');


--
-- Data for Name: specializations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.specializations VALUES
	(1, 'Internal Medicine', 1),
	(2, 'Surgery', 1),
	(3, 'Cardiology', 1),
	(4, 'Ophthalmology', 1),
	(5, 'Dermatology', 1),
	(6, 'Neurology', 1),
	(7, 'Oncology', 1),
	(8, 'Pets', 2),
	(9, 'Farm animals', 2),
	(10, 'Horse Medicine (Hipiatry)', 2),
	(11, 'Wildlife and Zoo Animals', 2);


--
-- Data for Name: stocks; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.stocks VALUES
	(1, 1, '2026-02-07', 19),
	(2, 3, '2026-11-03', 43),
	(3, 5, '2025-06-12', 44),
	(4, 6, '2026-03-09', 75),
	(5, 7, '2026-04-28', 86),
	(7, 9, '2025-09-06', 22),
	(8, 10, '2025-04-13', 11),
	(9, 11, '2025-03-15', 50),
	(10, 13, '2025-06-25', 75),
	(11, 14, '2024-11-30', 60),
	(13, 16, '2025-04-20', 30),
	(15, 18, '2025-02-28', 25),
	(16, 19, '2025-07-15', 20),
	(17, 20, '2025-08-10', 35),
	(18, 4, '2026-10-25', 43),
	(19, 2, '2025-02-28', 54),
	(20, 12, '2024-12-10', 60),
	(12, 15, '2025-01-05', 35),
	(21, 3, '2024-12-28', 32);


--
-- Data for Name: vet_customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.vet_customers VALUES
	(1, 1, 8),
	(2, 1, 9),
	(3, 1, 14),
	(4, 2, 13),
	(5, 2, 12),
	(6, 4, 17),
	(7, 4, 11),
	(8, 5, 8),
	(9, 6, 9),
	(10, 8, 10),
	(11, 9, 16),
	(35, 14, 53),
	(36, 15, 53);


--
-- Data for Name: vet_specializations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.vet_specializations VALUES
	(1, 1, 1),
	(2, 1, 8),
	(3, 2, 2),
	(4, 2, 8),
	(5, 3, 3),
	(6, 3, 8),
	(7, 4, 2),
	(8, 4, 9),
	(9, 5, 4),
	(10, 5, 8),
	(11, 6, 3),
	(12, 6, 9),
	(15, 8, 2),
	(16, 8, 11),
	(17, 9, 6),
	(18, 9, 9),
	(19, 9, 5),
	(24, 14, 2),
	(25, 15, 5),
	(26, 15, 6);


--
-- Data for Name: veterinarians; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.veterinarians VALUES
	(1, 'Carlee', 'Adshad', '0-506-265-8129', 'cadshad0@tinyurl.com', '02734 Dawn Trail', '2013-09-21'),
	(3, 'Broderic', 'Dahl', '0-596-889-3487', 'bdahl2@hostgator.com', '7 Esker Park', '2013-08-23'),
	(4, 'Ignatius', 'Sandifer', '0-536-386-5844', 'isandifer3@salon.com', '859 Sauthoff Point', '2013-06-07'),
	(5, 'Milt', 'Robens', '0-508-420-5763', 'mrobens4@hc360.com', '973 1st Avenue', '2018-10-06'),
	(6, 'Brewer', 'Grinnell', '0-506-360-9897', 'bgrinnell5@storify.com', '61 Vera Center', '2014-11-05'),
	(8, 'Jorry', 'Lamperti', '0-576-901-8785', 'jlamperti7@reddit.com', '9 Kipling Court', '2013-07-03'),
	(9, 'Davey', 'Cockerill', '0-558-281-6076', 'dcockerill8@phoca.cz', '41815 Anniversary Place', '2015-04-11'),
	(2, 'Brant', 'Shitliffe', '0-526-464-1586', 'bshitliffe1@prweb.com', '39223 Shelley Center', '2018-01-01'),
	(14, 'Ahmet', 'Alkan', '0-555-333-2442', 'ahmetmehmet@mail.com', '852 Serdivan ', '2024-12-11'),
	(15, 'Ahmet2', 'Alk', '0-555-333-3212', 'ahmetehmet@mail.com', '8512 Serdivan ', '2024-12-11');


--
-- Data for Name: villages; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.villages VALUES
	(5, 'Dumanalanı', 2, '10900'),
	(6, 'Abdiağa', 1, '17200'),
	(7, 'Dışbudak', 2, '10680'),
	(8, 'Çeşmealtı', 1, '17200'),
	(9, 'ÇavuşKöy', 1, '17200'),
	(10, 'Yeniçiftlik', 1, '17200');


--
-- Name: animal_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.animal_product_id_seq', 28, true);


--
-- Name: animal_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.animal_type_id_seq', 5, true);


--
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cities_id_seq', 2, true);


--
-- Name: companies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.companies_id_seq', 7, true);


--
-- Name: company_product_company_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.company_product_company_product_id_seq', 26, true);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_id_seq', 53, true);


--
-- Name: districts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.districts_id_seq', 3, true);


--
-- Name: medicine_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.medicine_categories_id_seq', 7, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_seq', 23, true);


--
-- Name: purchases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.purchases_id_seq', 21, true);


--
-- Name: sales_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sales_id_seq', 46, true);


--
-- Name: specialization_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.specialization_id_seq', 11, true);


--
-- Name: specialization_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.specialization_type_id_seq', 2, true);


--
-- Name: stocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.stocks_id_seq', 21, true);


--
-- Name: vet_customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vet_customers_id_seq', 36, true);


--
-- Name: vet_specializations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vet_specializations_id_seq', 26, true);


--
-- Name: veterinarians_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.veterinarians_id_seq', 15, true);


--
-- Name: villages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.villages_id_seq', 12, true);


--
-- Name: animal_product animal_product_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_product
    ADD CONSTRAINT animal_product_pk PRIMARY KEY (id);


--
-- Name: animal_types animal_type_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_types
    ADD CONSTRAINT animal_type_pk PRIMARY KEY (id);


--
-- Name: animal_types animal_type_species_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_types
    ADD CONSTRAINT animal_type_species_name_key UNIQUE (species_name);


--
-- Name: cities cities_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_name_key UNIQUE (name);


--
-- Name: cities city_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT city_pk PRIMARY KEY (id);


--
-- Name: companies companies_address_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_address_key UNIQUE (address);


--
-- Name: companies companies_email_address_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_email_address_key UNIQUE (email_address);


--
-- Name: companies companies_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_name_key UNIQUE (name);


--
-- Name: companies companies_phone_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_phone_no_key UNIQUE (phone_no);


--
-- Name: companies companies_tax_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_tax_number_key UNIQUE (tax_number);


--
-- Name: companies company_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT company_pk PRIMARY KEY (id);


--
-- Name: company_product company_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_product
    ADD CONSTRAINT company_product_pkey PRIMARY KEY (company_product_id);


--
-- Name: customers customer_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customer_pk PRIMARY KEY (id);


--
-- Name: customers customers_address_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_address_key UNIQUE (address);


--
-- Name: customers customers_email_address_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_email_address_key UNIQUE (email_address);


--
-- Name: customers customers_phone_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_phone_no_key UNIQUE (phone_no);


--
-- Name: districts district_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT district_pk PRIMARY KEY (id);


--
-- Name: districts districts_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT districts_name_key UNIQUE (name);


--
-- Name: foods food_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods
    ADD CONSTRAINT food_pkey PRIMARY KEY (product_id);


--
-- Name: medicine_categories medicine_categories_category_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicine_categories
    ADD CONSTRAINT medicine_categories_category_key UNIQUE (category);


--
-- Name: medicine_categories medicine_category_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicine_categories
    ADD CONSTRAINT medicine_category_pk PRIMARY KEY (id);


--
-- Name: medicines medicines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicines
    ADD CONSTRAINT medicines_pkey PRIMARY KEY (product_id);


--
-- Name: products product_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT product_pk PRIMARY KEY (product_id);


--
-- Name: products products_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_name_key UNIQUE (name);


--
-- Name: purchases purchase_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchase_pk PRIMARY KEY (id);


--
-- Name: sales sale_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sale_pk PRIMARY KEY (id);


--
-- Name: specializations specialization_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specializations
    ADD CONSTRAINT specialization_name_key UNIQUE (name);


--
-- Name: specializations specialization_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specializations
    ADD CONSTRAINT specialization_pk PRIMARY KEY (id);


--
-- Name: specialization_types specialization_type_abbreviation_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialization_types
    ADD CONSTRAINT specialization_type_abbreviation_key UNIQUE (abbreviation);


--
-- Name: specialization_types specialization_type_description_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialization_types
    ADD CONSTRAINT specialization_type_description_key UNIQUE (description);


--
-- Name: specialization_types specialization_type_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specialization_types
    ADD CONSTRAINT specialization_type_pk PRIMARY KEY (id);


--
-- Name: stocks stock_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stocks
    ADD CONSTRAINT stock_pk PRIMARY KEY (id);


--
-- Name: villages unique_village_name_postal_code; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.villages
    ADD CONSTRAINT unique_village_name_postal_code UNIQUE (name, postal_code);


--
-- Name: vet_customers vet_customers_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vet_customers
    ADD CONSTRAINT vet_customers_pk PRIMARY KEY (id);


--
-- Name: vet_specializations vet_specialization_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vet_specializations
    ADD CONSTRAINT vet_specialization_pk PRIMARY KEY (id);


--
-- Name: veterinarians veterinarian_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.veterinarians
    ADD CONSTRAINT veterinarian_pk PRIMARY KEY (id);


--
-- Name: veterinarians veterinarians_email_address_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.veterinarians
    ADD CONSTRAINT veterinarians_email_address_key UNIQUE (email_address);


--
-- Name: veterinarians veterinarians_phone_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.veterinarians
    ADD CONSTRAINT veterinarians_phone_no_key UNIQUE (phone_no);


--
-- Name: villages village_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.villages
    ADD CONSTRAINT village_pk PRIMARY KEY (id);


--
-- Name: vet_customers check_veterinarian_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_veterinarian_trigger BEFORE INSERT ON public.vet_customers FOR EACH ROW EXECUTE FUNCTION public.check_veterinarian();


--
-- Name: customers check_village_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER check_village_trigger BEFORE INSERT ON public.customers FOR EACH ROW EXECUTE FUNCTION public.check_village();


--
-- Name: animal_product animal_product_animal_type_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_product
    ADD CONSTRAINT animal_product_animal_type_fk FOREIGN KEY (animal_type_id) REFERENCES public.animal_types(id);


--
-- Name: animal_product animal_product_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.animal_product
    ADD CONSTRAINT animal_product_product_fk FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: company_product company_product_company_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_product
    ADD CONSTRAINT company_product_company_fk FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: company_product company_product_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.company_product
    ADD CONSTRAINT company_product_product_fk FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: customers customer_village_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customer_village_fk FOREIGN KEY (village_id) REFERENCES public.villages(id);


--
-- Name: districts district_city_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.districts
    ADD CONSTRAINT district_city_fk FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: foods food_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.foods
    ADD CONSTRAINT food_product_fk FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: medicines medicine_medicine_category_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicines
    ADD CONSTRAINT medicine_medicine_category_fk FOREIGN KEY (medicine_category_id) REFERENCES public.medicine_categories(id);


--
-- Name: medicines medicine_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medicines
    ADD CONSTRAINT medicine_product_fk FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: purchases purchase_company_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.purchases
    ADD CONSTRAINT purchase_company_fk FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: sales sale_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sale_product_fk FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: specializations specialization_specialization_type_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.specializations
    ADD CONSTRAINT specialization_specialization_type_fk FOREIGN KEY (specialization_type_id) REFERENCES public.specialization_types(id);


--
-- Name: stocks stock_product_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stocks
    ADD CONSTRAINT stock_product_fk FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- Name: vet_customers vet_customers_customers_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vet_customers
    ADD CONSTRAINT vet_customers_customers_fk FOREIGN KEY (customer_id) REFERENCES public.customers(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: vet_customers vet_customers_veterinarian_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vet_customers
    ADD CONSTRAINT vet_customers_veterinarian_fk FOREIGN KEY (veterinarian_id) REFERENCES public.veterinarians(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: vet_specializations vet_specialization_specialization_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vet_specializations
    ADD CONSTRAINT vet_specialization_specialization_fk FOREIGN KEY (specialization_id) REFERENCES public.specializations(id);


--
-- Name: vet_specializations vet_specialization_veterinarian_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vet_specializations
    ADD CONSTRAINT vet_specialization_veterinarian_fk FOREIGN KEY (veterinarian_id) REFERENCES public.veterinarians(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: villages village_district_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.villages
    ADD CONSTRAINT village_district_fk FOREIGN KEY (district_id) REFERENCES public.districts(id);


--
-- PostgreSQL database dump complete
--

