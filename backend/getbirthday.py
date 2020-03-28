import json
import boto3
from pprint import pprint
from datetime import date
import dateutil.parser

def lambda_handler(event, context):


    # Get Username
    username = 123
    try:
        username = event['pathParameters']['username']
    except:
        pass

    # Validate
    # Unfortunately API Gateway doesn't support request path parameter validation
    if not username.isalpha():
        return {
            'statusCode': 400,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'status': 'username format is invalid'})
        } 

    try:
        dynamodb = boto3.client('dynamodb')
        response = dynamodb.get_item(TableName='birthdays', Key={'username':{'S':username}})
        pprint(response["ResponseMetadata"]["HTTPStatusCode"])
        pprint(response["Item"])
        dobstr = response["Item"]["dob"]["S"]
        dob = dateutil.parser.parse(dobstr)
        today = date.today()
        nextbday = date(today.year, dob.month, dob.day)
        if nextbday < today:
            nextbday = date(today.year + 1, dob.month, dob.day)
        days = (nextbday - today).days

        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'dob': dobstr, 'days': days})
        }
    except:
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'status': 'error retrieving dob'})
        }