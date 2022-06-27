## Proposta

Realizar uma prova de conceito sobre a utilização da CouchDB para recuperação de dados de forma otimizada utilizando-se de criação de índices e view para a recuperação dos dados.

## Passos

## 1 - criação do banco de dados CouchDB em container

cd docker
docker-compose up -d

Fauxton url : http://127.0.0.1:15984/_utils/

## 2 - Criação do banco de dados através do utilitário cURL

Você pode criar o banco de dados CouchDB envindo requisições HTTP usando o método "PUT"

$ curl -X PUT http://admin:adminpw@localhost:15984/couchtest

Após a execução é retornado o JSON contendo "ok" que indica que a operação was realizada com sucesso.

Resultado esperado :
{"ok":true}

Atráves do método "GET" é possível verificar se o banco de dados foi criado. Aqui é possível observar o nome do banco de dados criado.

## Verification
Verify whether the database is created, by listing out all the databases as shown below. Here you can observe the name of a newly created database, "sample" in the list.

$ curl -X GET http://admin:adminpw@localhost:15984/_all_dbs

Resultado esperado :
["couchtest"]

## 3 - Creating 1000 Document using cURL Utility

Para simplificar o script "/script/loader.sh" pode ser executado para criar 1000 documentos automaticamente com conteúdo dos atributos aleatório.

Caso, opte para não executar o script, a linha de comando abaixo ser executada para criar apenas 1(um) documento.

obs.: caso deseje realizar mais de uma execução lembre-se de alterar o conteúdo atributo "_id".

$ curl -X POST http://admin:adminpw@localhost:15984/couchtest -H 'Content-Type: application/json' -d "{\"_id\": \"0000000005001\",\"attrib1\": \"attrib1\",\"attrib2\": \"attrib2\",\"attrib3\": \"attrib3\",\"attrib4\": [{\"attrib5\": \"attrib5\",\"attrib6\": \"attrib6\"}],\"attrib7\": \"attrib7\",\"attrib8\": \"attrib8\",\"attrib9\": \"attrib9\",\"attrib10\": \"attrib10\",\"attrib11\": \"attrib11\",\"attrib12\": \"attrib12\",\"attrib13\": \"attrib13\",\"attrib14\": \"attrib14\",\"attrib15\":\"attrib15\",\"attrib16\": \"attrib16\",\"attrib17\": \"attrib17\",\"attrib18\": \"attrib18\",\"attrib19\": \"attrib19\",\"attrib20\": \"attrib20\"}"

Resultado esperado :
{"ok":true,"id":"0000000005001","rev":"1-2d6d9d122ca2bd44c5ef0e4e91e4e899"}

## 4 - Criação de Index

Existem duas formas de criar os índices, uma pela interface do Fauxton ou atrávés do utilitário cURL.

On Fauxton http://localhost:15984/_utils/#database/couchtest/_index create the following index.

or 

$ curl -X POST http://admin:adminpw@localhost:15984/couchtest/_index -H "Content-Type:application/json" -d '{"index": {"fields": ["_id"]}, "name": "_id-index", "type": "json"}'

Resultado esperado :
{"result":"created","id":"_design/44f1bd90e7d48bc6045c3d60023bfb08c4cd91a2","name":"_id-index"}

Importante, caso o atributo utilizado para filtro na consulta não seja indexado, o couchDB vai sugerir a criação do mesmo conforma abaixo :

"warning": "The number of documents examined is high in proportion to the number of results returned. Consider adding a more specific index to improve this."}

Recebendo essa mensagens após a realização das consultas é extremamento aconselhavél a criação do índice que trará ganhos muito significativos para a recuperação de dados.

## 5 - Listar os Índices

$ curl -X GET http://admin:adminpw@localhost:15984/couchtest/_index

## 6 - Recuperar documento completo pelo atributo "_id"

$ curl -X POST http://admin:adminpw@localhost:15984/couchtest/_find -H 'Content-Type: application/json' -d '{"selector": {"_id": {"$eq": "00000000000992"}}}'

## 7 - Recuperar documentos, indicando os atributos, pelo intervalo do atributo "_id"

$ curl -X POST http://admin:adminpw@localhost:15984/couchtest/_find -H "Content-Type:application/json" -d '{"selector": {"_id": {"$gte": "00000000000992", "$lte": "000000000009999"}}, "fields": ["_id", "attrib1", "attrib2", "_rev"], "limit": 5, "skip": 0}'

## 8 - Criação de View

Na view é possível determinar somente os atributos necessários de um documento para ser recuperado sem a necessidade de declaração explícita dos mesmos.

$ curl -X PUT http://admin:adminpw@localhost:15984/couchtest/_design/my_view -d '{"views":{"my_filter":{"map":"function(doc) {emit(doc._id,  {attrib1:doc.attrib1,attrib2:doc.attrib2,attrib3:doc.attrib3,rev:doc._rev })}"}}}'

Resultado esperado :
{"ok":true,"id":"_design/my_view","rev":"1-c9fb23c32eb0cab20393c9e96d844bb8"}

## Recuperar todos os documentos da view

$ curl -X GET http://admin:adminpw@localhost:15984/couchtest/_design/my_view/_view/my_filter

## Recuperar apenas um documento da view

$ curl -X GET 'http://admin:adminpw@localhost:15984/couchtest/_design/my_view/_view/my_filter?key="00000000000011"'

