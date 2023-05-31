import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options

driver_path = "C:\\Intel\\Software"
DLab_url = "https://ssn.trainings.dlabanalytics.com/"
chrome_options = Options()
chrome_options.add_argument("--incognito")

driver = webdriver.Chrome(executable_path=driver_path, options=chrome_options)

driver.get(DLab_url)
driver.find_element(By.ID, "details-button").click()
driver.find_element(By.ID, "proceed-link").click()
time.sleep(5)

# Signing in to DLab
driver.find_element(By.ID, "social-epam-idp").click()
time.sleep(5)
driver.find_element(By.CSS_SELECTOR, "input[type=email]").send_keys("phaneendra_bhupathiraju@epam.com")
driver.find_element(By.CSS_SELECTOR, "input[type=submit]").click()
time.sleep(2)
driver.find_element(By.CSS_SELECTOR, "input[name=passwd]").send_keys("Ka@21@kab7")
driver.find_element(By.ID, "idSIButton9").click()
time.sleep(50)

# Start the instance
driver.find_element(By.CSS_SELECTOR, "span.actions").click()
driver.find_element(By.CSS_SELECTOR, "div.ng-tns-c13-1").click()
time.sleep(2)
driver.find_element(By.CSS_SELECTOR, "span.mat-tooltip-trigger.ng-tns-c13-1.ng-star-inserted").click()
driver.find_element(By.CSS_SELECTOR, "a.ellipsis.none-select.resources-url.mat-tooltip-trigger").click()
time.sleep(5)

# Switch to Home page window
main_window = driver.current_window_handle
all_windows = driver.window_handles
for window in all_windows:
    if window != main_window:
        driver.switch_to.window(window)
        break
driver.find_element(By.ID, "details-button").click()
driver.find_element(By.ID, "proceed-link").click()
time.sleep(10)
driver.find_element(By.XPATH, "//span[text()='DQChecks_Project.ipynb']").click()

# Switch to jupyter notebook and run the file
dq_checks_window = driver.current_window_handle
all_windows = driver.window_handles
for window in all_windows:
    if window != main_window and window != dq_checks_window:
        driver.switch_to.window(window)
        break
time.sleep(20)
driver.find_element(By.CSS_SELECTOR, "span.toolbar-btn-label").click()
print("Successfully run the notebook")

driver.quit()