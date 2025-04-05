;; Generator Registration Contract
;; Records sources of hazardous medical waste

(define-data-var last-generator-id uint u0)

(define-map generators
  { generator-id: uint }
  {
    name: (string-utf8 100),
    location: (string-utf8 100),
    license-number: (string-utf8 50),
    waste-types: (list 10 (string-utf8 50)),
    active: bool,
    registration-time: uint
  }
)

(define-public (register-generator (name (string-utf8 100)) (location (string-utf8 100)) (license-number (string-utf8 50)) (waste-types (list 10 (string-utf8 50))))
  (let
    (
      (new-id (+ (var-get last-generator-id) u1))
    )
    (var-set last-generator-id new-id)
    (map-set generators
      { generator-id: new-id }
      {
        name: name,
        location: location,
        license-number: license-number,
        waste-types: waste-types,
        active: true,
        registration-time: block-height
      }
    )
    (ok new-id)
  )
)

(define-public (update-generator (generator-id uint) (name (string-utf8 100)) (location (string-utf8 100)) (license-number (string-utf8 50)) (waste-types (list 10 (string-utf8 50))))
  (let
    (
      (generator (unwrap! (map-get? generators { generator-id: generator-id }) (err u404)))
    )
    (map-set generators
      { generator-id: generator-id }
      {
        name: name,
        location: location,
        license-number: license-number,
        waste-types: waste-types,
        active: (get active generator),
        registration-time: (get registration-time generator)
      }
    )
    (ok true)
  )
)

(define-public (deactivate-generator (generator-id uint))
  (let
    (
      (generator (unwrap! (map-get? generators { generator-id: generator-id }) (err u404)))
    )
    (map-set generators
      { generator-id: generator-id }
      {
        name: (get name generator),
        location: (get location generator),
        license-number: (get license-number generator),
        waste-types: (get waste-types generator),
        active: false,
        registration-time: (get registration-time generator)
      }
    )
    (ok true)
  )
)

(define-read-only (get-generator (generator-id uint))
  (map-get? generators { generator-id: generator-id })
)

(define-read-only (is-active-generator (generator-id uint))
  (default-to false (get active (map-get? generators { generator-id: generator-id })))
)
