/* =========================================
   TELECOM CUSTOMER CHURN ANALYSIS (SQL)
   ========================================= */

/* Таблица telecom содержит данные клиентов:
   customerID, gender, SeniorCitizen, Partner,
   tenure, PhoneService, InternetService,
   Contract, PaymentMethod, MonthlyCharges,
   TotalCharges, Churn
*/


/* =====================================================
   1. ОБЩЕЕ КОЛИЧЕСТВО КЛИЕНТОВ
   ===================================================== */
SELECT COUNT(*) AS total_customers
FROM telecom;



/* =====================================================
   2. ОБЩИЙ CHURN RATE (ключевая метрика)
   ===================================================== */
SELECT 
    Churn,
    COUNT(*) AS customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM telecom
GROUP BY Churn;



/* =====================================================
   3. CHURN RATE ПО ТИПУ КОНТРАКТА
   ===================================================== */
SELECT 
    Contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 2
    ) AS churn_rate_percent
FROM telecom
GROUP BY Contract
ORDER BY churn_rate_percent DESC;



/* =====================================================
   4. CHURN ПО СПОСОБУ ОПЛАТЫ
   ===================================================== */
SELECT 
    PaymentMethod,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 2
    ) AS churn_rate_percent
FROM telecom
GROUP BY PaymentMethod
ORDER BY churn_rate_percent DESC;



/* =====================================================
   5. CHURN ПО ТИПУ ИНТЕРНЕТА
   ===================================================== */
SELECT 
    InternetService,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 
        / COUNT(*), 2
    ) AS churn_rate_percent
FROM telecom
GROUP BY InternetService
ORDER BY churn_rate_percent DESC;



/* =====================================================
   6. СРЕДНИЙ ДОХОД (ARPU)
   ===================================================== */
SELECT 
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_revenue
FROM telecom;



/* =====================================================
   7. ДОХОД ПО ГРУППАМ (ушёл / остался)
   ===================================================== */
SELECT 
    Churn,
    ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_payment,
    ROUND(AVG(TotalCharges), 2) AS avg_total_payment
FROM telecom
GROUP BY Churn;



/* =====================================================
   8. АНАЛИЗ СТАЖА КЛИЕНТОВ (tenure)
   ===================================================== */
SELECT 
    Churn,
    ROUND(AVG(tenure), 1) AS avg_tenure_months
FROM telecom
GROUP BY Churn;



/* =====================================================
   9. ТОП РИСКОВЫЙ СЕГМЕНТ (комбинация факторов)
   ===================================================== */
SELECT 
    Contract,
    InternetService,
    PaymentMethod,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) *100.0 / COUNT(*), 2
    ) AS churn_rate
FROM telecom
GROUP BY Contract, InternetService, PaymentMethod
HAVING COUNT(*) > 50
ORDER BY churn_rate DESC;



/* =====================================================
   10. СЕГМЕНТАЦИЯ КЛИЕНТОВ ПО ДОХОДУ
   ===================================================== */
SELECT 
    CASE 
        WHEN MonthlyCharges < 40 THEN 'Low revenue'
        WHEN MonthlyCharges BETWEEN 40 AND 80 THEN 'Medium revenue'
        ELSE 'High revenue'
    END AS revenue_segment,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned,
    ROUND(
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) *100.0 / COUNT(*), 2
    ) AS churn_rate
FROM telecom
GROUP BY revenue_segment
ORDER BY churn_rate DESC;
