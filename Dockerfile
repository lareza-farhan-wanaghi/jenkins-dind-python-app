FROM cdrx/pyinstaller-linux:python2

COPY sources /src

WORKDIR /src

RUN pyinstaller -F add2vals.py

ENTRYPOINT ["./dist/add2vals","2", "1"]
