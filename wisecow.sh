#!/usr/bin/env bash

SRVPORT=4499
RSPFILE=response

rm -f $RSPFILE
mkfifo $RSPFILE

get_api() {
    read line
    echo $line
}

handleRequest() {
    # 1) Process the request
    get_api
    mod=`fortune`

    # Define the background color (Light Blue or Light Yellow)
    BACKGROUND_COLOR="#e0f7fa"  # Light Blue (Change to #fff9c4 for Light Yellow)

    cat <<EOF > $RSPFILE
HTTP/1.1 200 OK
Content-Type: text/html; charset=UTF-8

<html>
<head>
    <title>Wisdom Served with Cowsay</title>
    <style>
        body {
            font-family: 'Courier New', monospace;
            background-color: $BACKGROUND_COLOR;  /* Light Blue or Light Yellow */
            text-align: center;
            color: #333;
            margin-top: 50px;
        }
        pre {
            background-color: #fff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            width: 70%;
            margin: 0 auto;
            font-size: 20px;
            text-align: center;
            border: 2px solid #3498db;
            max-width: 700px;
        }
        h1 {
            color: #3498db;
        }
        footer {
            position: fixed;
            bottom: 10px;
            width: 100%;
            text-align: center;
            font-size: 12px;
            color: #7f8c8d;
        }
    </style>
</head>
<body>
    <h1>Wisdom Served With Cowsay</h1>
    <pre>`cowsay $mod`</pre>
    <footer>Powered by Fortune & Cowsay</footer>
</body>
</html>
EOF
}

prerequisites() {
    command -v cowsay >/dev/null 2>&1 &&
    command -v fortune >/dev/null 2>&1 || 
        { 
            echo "Install prerequisites."
            exit 1
        }
}

main() {
    prerequisites
    echo "Wisdom served on port=$SRVPORT..."

    while [ 1 ]; do
        cat $RSPFILE | nc -lN $SRVPORT | handleRequest
        sleep 0.01
    done
}

main
