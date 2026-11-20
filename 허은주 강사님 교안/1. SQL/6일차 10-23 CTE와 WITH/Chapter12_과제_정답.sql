-- Q1.
CREATE TABLE public.edu_inventory (
    product_code VARCHAR(30) PRIMARY KEY,
    qty INTEGER NOT NULL CHECK (qty >= 0),
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Q2.
INSERT INTO public.edu_inventory (product_code, qty)
VALUES ('P001', 10), ('P002', 20);

-- Q3.
UPDATE public.edu_inventory
SET qty = qty + 5,
    updated_at = CURRENT_TIMESTAMP
WHERE product_code = 'P001'
RETURNING *;

-- Q4.
BEGIN;
DELETE FROM public.edu_inventory
WHERE product_code = 'P002'
RETURNING *;
ROLLBACK;

SELECT *
FROM public.edu_inventory
WHERE product_code = 'P002';

-- Q5.
INSERT INTO public.edu_inventory (product_code, qty)
VALUES ('P001', 99)
ON CONFLICT (product_code)
DO UPDATE SET
    qty = EXCLUDED.qty,
    updated_at = CURRENT_TIMESTAMP
RETURNING *;
