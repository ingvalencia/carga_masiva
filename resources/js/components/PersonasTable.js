import React, { useState, useEffect } from 'react';
import { Table, Pagination, Spinner, ListGroup, Badge } from 'react-bootstrap';
import axios from 'axios';

export default function PersonasTable() {
  const [personas, setPersonas] = useState([]);
  const [detalles, setDetalles] = useState(null);
  const [personaSeleccionada, setPersonaSeleccionada] = useState(null);
  const [paginaActual, setPaginaActual] = useState(0);
  const [cargando, setCargando] = useState(false);


  const fetchPersonas = async () => {
    setCargando(true);
    try {
      const res = await axios.get(`http://localhost:8000/api/personas?offset=${paginaActual * 100}`);
      setPersonas(res.data.personas);
    } catch (error) {
      console.error("Error al cargar personas:", error);
    } finally {
      setCargando(false);
    }
  };


  const fetchDetalles = async (personaId) => {
    try {
      const res = await axios.get(`http://localhost:8000/api/personas/${personaId}/detalles`);
      setDetalles(res.data);
      setPersonaSeleccionada(personaId);
    } catch (error) {
      console.error("Error al cargar detalles:", error);
    }
  };

  useEffect(() => { fetchPersonas(); }, [paginaActual]);

  return (
    <div className="mt-4">
      {cargando ? (
        <div className="text-center">
          <Spinner animation="border" variant="primary" />
          <p>Cargando datos...</p>
        </div>
      ) : (
        <>
          <Table striped bordered hover className="shadow-sm">
            <thead className="bg-light">
              <tr>
                <th>Nombre</th>
                <th>Apellido Paterno</th>
                <th>Apellido Materno</th>
              </tr>
            </thead>
            <tbody>
              {personas.map((persona) => (
                <tr
                  key={persona.id}
                  onClick={() => fetchDetalles(persona.id)}
                  style={{ cursor: 'pointer' }}
                  className={personaSeleccionada === persona.id ? 'table-active' : ''}
                >
                  <td>{persona.nombre}</td>
                  <td>{persona.paterno}</td>
                  <td>{persona.materno}</td>
                </tr>
              ))}
            </tbody>
          </Table>

          <Pagination className="mt-3 justify-content-center">
            <Pagination.Prev
              onClick={() => {
                setPaginaActual(p => Math.max(0, p - 1));
                setDetalles(null);
              }}
              disabled={paginaActual === 0}
            />
            <Pagination.Item active>{paginaActual + 1}</Pagination.Item>
            <Pagination.Next
              onClick={() => {
                setPaginaActual(p => p + 1);
                setDetalles(null);
              }}
              disabled={personas.length < 100}
            />
          </Pagination>
        </>
      )}

      {/* Panel de Detalles */}
      {detalles && (
        <div className="mt-4 p-4 border rounded shadow-sm bg-white">
          <h4 className="mb-4 text-primary">
            <i className="bi bi-person-lines-fill me-2"></i>
            Detalles de Contacto
          </h4>

          <div className="mb-4">
            <h5>
              <Badge bg="info" className="me-2">
                <i className="bi bi-telephone"></i>
              </Badge>
              Teléfonos
            </h5>
            {detalles.telefonos.length > 0 ? (
              <ListGroup>
                {detalles.telefonos.map((tel) => (
                  <ListGroup.Item key={tel.id} className="d-flex align-items-center">
                    <i className="bi bi-telephone-outbound me-2 text-success"></i>
                    <span className="fw-bold">{tel.numero}</span>
                  </ListGroup.Item>
                ))}
              </ListGroup>
            ) : (
              <div className="text-muted">No hay teléfonos registrados</div>
            )}
          </div>

          <div>
            <h5>
              <Badge bg="warning" className="me-2">
                <i className="bi bi-geo-alt"></i>
              </Badge>
              Direcciones
            </h5>
            {detalles.direcciones.length > 0 ? (
              <ListGroup>
                {detalles.direcciones.map((dir) => (
                  <ListGroup.Item key={dir.id}>
                    <div className="d-flex align-items-center mb-1">
                      <i className="bi bi-house-door me-2 text-primary"></i>
                      <strong>{dir.calle} {dir.numero_ext}</strong>
                      {dir.numero_int && <span>, Int. {dir.numero_int}</span>}
                    </div>
                    <div className="ms-4">
                      <small className="text-muted">
                        {dir.colonia}, CP: {dir.cp}
                      </small>
                    </div>
                  </ListGroup.Item>
                ))}
              </ListGroup>
            ) : (
              <div className="text-muted">No hay direcciones registradas</div>
            )}
          </div>
        </div>
      )}
    </div>
  );
}
