import os
import json
import logging
import botocore
import boto3


logLevel = os.getenv("LOG_LEVEL", "DEBUG").upper()
logger   = logging.getLogger()
logger.setLevel(logLevel)


def lambda_handler(event, context):
    demo_logger()
    list_buckets()
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }


def demo_logger():
    logger.debug(f"D: In {__name__}")
    logger.info(f"I: In {__name__}")
    logger.warning(f"W: In {__name__}")
    logger.error(f"E: In {__name__}")
    logger.critical(f"C: In {__name__}")


def list_buckets():
    s3_client = boto3.client('s3')
    try:
        response = s3_client.list_buckets()
    except botocore.exceptions.ClientError as exception:
        logger.exception(f"Unexpected Error: {exception}")
    for bucket in response['Buckets']:
        logger.info(f"Processing bucket {bucket['Name']}")



if __name__ == '__main__':
    logging.basicConfig(level=logLevel)
    demo_logger()
    list_buckets()
