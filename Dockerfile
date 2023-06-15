FROM cdrx/pyinstaller-linux:python2

COPY sources /src

WORKDIR /src

RUN pyinstaller -F add2vals.py

RUN echo "test"

CMD ["./dist/add2vals", 2, 1]
