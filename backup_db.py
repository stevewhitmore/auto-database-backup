from selenium import webdriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import StaleElementReferenceException
import configparser
import os
import sys
import datetime
import time 

config = configparser.ConfigParser()
config.read('config.txt')
download_destination = config['FOLLOWUP']['DESTINATION_FOLDER']

options = webdriver.ChromeOptions()
options.add_argument('--ignore-certificate-errors')
options.add_argument('--test-type')
options.add_argument('--headless')
options.binary_location = '/usr/bin/chromium-browser'

driver = webdriver.Chrome(options=options)
driver.command_executor._commands["send_command"] = ("POST", '/session/$sessionId/chromium/send_command')
params = {'cmd': 'Page.setDownloadBehavior', 'params': {'behavior': 'allow', 'downloadPath': download_destination}}
command_result = driver.execute("send_command", params)



def login_to_database_page():
    loginURL = config['DATABASE_ACCESS']['PHP_MYADMIN_URL']
    username = config['DATABASE_ACCESS']['USERNAME']
    password = config['DATABASE_ACCESS']['PASSWORD']

    driver.get(loginURL)
    driver.find_element_by_id('login-form-user').clear()
    driver.find_element_by_id('login-form-user').send_keys(username)
    driver.find_element_by_id('login-form-password').clear()
    driver.find_element_by_id('login-form-password').send_keys(password)
    driver.find_element_by_css_selector('.button.button--primary.button--with-loader.button--full-width.PfxInputSubmit').click()

    navigate_to_export_tab()


def navigate_to_export_tab():
    export_tab_xpath = '//*[@id="topmenu"]/li[4]/a'

    try:
        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.XPATH, export_tab_xpath)))

        driver.find_element_by_xpath(export_tab_xpath).click()

    except StaleElementReferenceException as e:
        raise e


def initiate_download():
    download_button_xpath = '//*[@id="buttonGo"]'

    try:
        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.XPATH, download_button_xpath)))

        driver.find_element_by_xpath(download_button_xpath).click()

    except StaleElementReferenceException as e:
        raise e


# def update_file_name():
    # time.sleep(4)
    # todays_date = str(datetime.date.today())
    # database_name = config['DATABASE_ACCESS']['DATABASE_NAME']
    # filename = database_name + '-' + todays_date + '.sql'
    # new_filename = website_name + '-' + filename
    # os.chdir(download_destination)
    # os.rename(filename, new_filename)


def run_script():
    login_to_database_page()
    initiate_download()
    # update_file_name()


try:
    run_script()
except RuntimeError:
    print('RuntimeError occurred. Exiting...')
    driver.quit()
    