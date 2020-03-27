import json
import boto3
from pprint import pprint

def lambda_handler(event, context):

    bodystr = event['body']
    print(bodystr)
    bodyobj = json.loads(bodystr)
    username = bodyobj['username']
    dob = bodyobj['dob']

    dynamodb = boto3.client('dynamodb')
    response = dynamodb.put_item(TableName='birthdays', Item={'username':{'S':username}, 'dob':{'S':dob}})
    pprint(response["ResponseMetadata"]["HTTPStatusCode"])

    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps({'status': 'success'})
    }
