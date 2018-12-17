import argparse
import requests

def download_write_file(url_link, file_name):
    """
    function to download online content and write to files
    Take 2 args, url and file name
    """
    file_download = requests.get(url_link, allow_redirects=True)
    open(file_name, 'wb').write(file_download.content)

def Main():

    parser = argparse.ArgumentParser(description='Download ')
    parser.add_argument("url_link", help="A string with the url/ftp link")
    parser.add_argument("file_name", help="Sample file name")

    args = parser.parse_args()
    url = args.url_link
    file = args.file_name

    download_write_file(url, file)

if __name__ == '__main__':
    Main()
