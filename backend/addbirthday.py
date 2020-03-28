import json
import boto3
from pprint import pprint
import datetime

def lambda_handler(event, context):

    # Get Username
    try:
        username = event['pathParameters']['username']
    except:
        pass

    # Get DOB
    try:
        bodystr = event['body']
        #print(bodystr)
        bodyobj = json.loads(bodystr)
        dob = bodyobj['dob']
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

    print_format = 'YYYY-MM-DD'
    strptime_format = '%Y-%m-%d'
    doberror = False
    try:
        dt = datetime.datetime.strptime(dob, strptime_format)
    except ValueError:
        doberror = True

    today = datetime.date.today()
    todaystr = today.strftime("%Y-%m-%d")
    if dob > todaystr:
        return {
            'statusCode': 400,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'status': 'dob must be today or earlier'})
        } 

    if doberror:
        return {
            'statusCode': 400,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'status': 'dob format is invalid'})
        } 

    try:
        dynamodb = boto3.client('dynamodb')
        response = dynamodb.put_item(TableName='birthdays', Item={'username':{'S':username}, 'dob':{'S':dob}})
        pprint(response)
        return {
            'statusCode': 204,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'status': 'success'})
        }
    except:
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'status': 'error saving to database'})
        }